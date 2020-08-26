defmodule Harness.Renderer.Run do
  @moduledoc false

  # Describes a single run of a render, which is unique to both
  # - generation path (where the files are being created)
  # - generator module (which generator is producing files)

  alias Harness.{Pkg, Renderer}
  alias Harness.Renderer.Utils

  defstruct [
    :output_directory,
    :generator_module,
    :generator_config,
    :generator_name,
    :package_directory,
    :files
  ]

  def source(generator_module, pkg_config, output_directory) do
    pkg_path = Pkg.path(generator_module)
    otp_app = Pkg.otp_app(generator_module)
    this_pkg_config = Keyword.get(pkg_config, otp_app, [])

    generator_config =
      this_pkg_config |> generator_module.cast() |> flatten_config()

    %__MODULE__{
      output_directory: output_directory,
      generator_name: otp_app,
      generator_module: generator_module,
      generator_config: generator_config,
      package_directory: pkg_path
    }
  end

  def source_files(%__MODULE__{package_directory: pkg_path} = run) do
    files_in_pkg =
      pkg_path
      |> Path.join("/**")
      |> Path.wildcard(match_dot: true)
      |> Enum.reject(fn filename ->
        Enum.any?(Harness.ignore_patterns(), &Regex.match?(&1, filename))
      end)

    # by including the `pkg_path`, we setup harness to later create the
    # `.harness/` directory before any other files/dirs/links
    files_in_pkg = [pkg_path | files_in_pkg]

    files =
      files_in_pkg
      |> Enum.map(&Renderer.File.source(&1, run, File.lstat!(&1).type))
      |> Enum.reject(&(&1.output_path == Path.join(".harness", "pkg.exs")))

    links =
      run.generator_config
      |> run.generator_module.links()
      |> Enum.map(&Renderer.File.source(&1, run, :symlink))

    directories_for_links =
      links
      |> Enum.map(&directories_for_link/1)
      |> List.flatten()

    %__MODULE__{run | files: files ++ directories_for_links ++ links}
  end

  defp flatten_config(%{__struct__: _} = config) do
    config
    |> Map.delete(:__struct__)
    |> Map.to_list()
  end

  # replaces variables in path names with the variables' value
  def expand_paths(%__MODULE__{} = run) do
    expanded_files =
      run.files
      |> Enum.map(fn file ->
        %{
          file
          | output_path: substitute_vars(file.output_path, run.generator_config)
        }
      end)

    %{run | files: expanded_files}
  end

  defp substitute_vars(path, flat_config) do
    Enum.reduce(flat_config, path, fn {config_key, config_val}, acc ->
      if String.contains?(path, "$#{config_key}$") do
        String.replace(acc, "$#{config_key}$", config_val |> to_string())
      else
        acc
      end
    end)
  end

  defp directories_for_link(%Renderer.File{output_path: path, type: :symlink}) do
    directories_for_link(path, [])
  end

  defp directories_for_link(path, directories) do
    up_one_dir = Path.dirname(path)

    if up_one_dir == "." do
      directories
    else
      directories_for_link(up_one_dir, [directory(up_one_dir) | directories])
    end
  end

  defp directory(path) do
    %Renderer.File{
      output_path: path,
      source_path: path,
      type: :directory
    }
  end

  def file_composition(%__MODULE__{files: files}) do
    files
    |> Utils.count_composition()
    |> Utils.format_composition()
  end
end
