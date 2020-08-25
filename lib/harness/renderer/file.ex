defmodule Harness.Renderer.File do
  @moduledoc false

  alias Harness.Renderer.{Run, Helpers, Utils}

  # a common interface for being a file

  defstruct [:source_path, :output_path, :type, root?: false]

  def print(%__MODULE__{root?: true} = root) do
    root.output_path
  end

  def print(%__MODULE__{type: :symlink} = file) do
    filename = file.output_path |> Path.basename() |> Utils.bright_cyan()

    filename <> " -> " <> file.source_path
  end

  def print(%__MODULE__{type: :directory, output_path: path}) do
    path |> Path.basename() |> Utils.bold_blue()
  end

  def print(%__MODULE__{type: :regular} = file) do
    Path.basename(file.output_path)
  end

  def source(path, _path, :symlink) do
    %__MODULE__{
      source_path: link_source_path(path),
      output_path: path,
      type: :symlink
    }
  end

  def source(path, %Run{package_directory: pkg_path}, type) do
    file_relative_to_project = String.trim_leading(path, pkg_path)

    %__MODULE__{
      source_path: path,
      output_path: Path.join(".harness", file_relative_to_project),
      type: type
    }
  end

  @spec generate(%Run{}, %__MODULE__{}) :: String.t()
  def generate(%Run{}, %__MODULE__{root?: true}), do: ""

  def generate(%Run{} = run, %__MODULE__{type: :regular} = file) do
    path = Path.join(run.output_directory, file.output_path)

    generated_contents =
      file.source_path
      |> EEx.eval_file(
        [assigns: run.generator_config],
        functions: [{Helpers, Helpers.__info__(:functions)}]
      )
      # this shouldn't be necessary but it prevents a strange dialyzer warn
      |> format_elixir(path, Path.extname(file.source_path))

    with {:ok, prior_contents} <- File.read(path),
         true <- prior_contents == generated_contents do
      Utils.green("unchanged")
    else
      {:error, :enoent} ->
        File.write!(path, generated_contents)

        Utils.yellow("written")

      false = _contents_have_been_changed ->
        File.write!(path, generated_contents)

        Utils.yellow("changed")
    end
  end

  def generate(%Run{} = run, %__MODULE__{type: :directory} = dir) do
    path = Path.join(run.output_directory, dir.output_path)

    if File.dir?(path) do
      Utils.green("exists")
    else
      File.mkdir_p!(path)

      Utils.yellow("created")
    end
  end

  def generate(%Run{} = run, %__MODULE__{type: :symlink} = link) do
    to = Path.join(run.output_directory, link.output_path)
    from = link.source_path

    with {:ok, %{type: :symlink}} <- File.lstat(to),
         {:ok, ^from} <- File.read_link(to) do
      Utils.green("exists")
    else
      {:error, :enoent} ->
        File.ln_s!(from, to)

        Utils.yellow("linked")

      {:ok, _other_path} ->
        File.rm!(to)
        File.ln_s!(from, to)

        Utils.yellow("re-linked")
    end
  end

  def remove!(%__MODULE__{type: :symlink, output_path: path}) do
    if path |> link_file_exists? do
      path |> File.rm!()
    end

    if path |> Path.dirname() |> directory_is_empty? do
      path |> Path.dirname() |> File.rmdir!()
    end
  end

  # this path is interesting to generate because you need to preceed the path
  # with a number of ../'s equal to the directory depth of the file being
  # generated
  defp link_source_path(link_path) do
    number_of_dot_dots =
      link_path
      |> Path.split()
      |> Enum.drop(-1)
      |> Enum.count()

    all_the_dot_dots =
      Stream.repeatedly(fn -> ".." end)
      |> Enum.take(number_of_dot_dots)

    [link_path, ".harness" | all_the_dot_dots]
    |> Enum.reverse()
    |> Path.join()
  end

  defp format_elixir(generated_code, filename, ".ex") do
    formatted_code =
      generated_code
      |> to_string()
      |> Code.format_string!(file: filename)
      |> to_string()

    formatted_code <> "\n"
  end

  defp format_elixir(generated_code, filename, ".exs") do
    # let's just pretend it's .ex
    format_elixir(generated_code, filename, ".ex")
  end

  defp format_elixir(generated_code, _filename, _any_other_extension) do
    generated_code
  end

  defp directory_is_empty?(path) do
    File.ls!(path) == []
  end

  # `File.exists?/1` will return `false` for broken links, which causes an
  # issue when cleaning multiple generators
  defp link_file_exists?(path) do
    :elixir_utils.read_link_type(path) == {:ok, :symlink}
  end
end
