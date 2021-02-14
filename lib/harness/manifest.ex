defmodule Harness.Manifest do
  @moduledoc """
  A local project's harness configuration
  """

  alias Mix.ProjectStack

  @version_match_msg "Could not parse the harness.exs manifest because the " <>
                       "manifest version is not compatible with the installed harness " <>
                       "archive. Please update the manifest or the harness archive."

  defstruct generators: [],
            pkg_config: [],
            deps: [],
            skip_files: [],
            manifest_version: nil

  @doc false
  def version, do: "~> 2.0"

  @doc false
  def manifest_file, do: "harness.exs"

  @doc "reads the manifest file from the path"
  def read(path) do
    with false <- File.dir?(path),
         {config, _files} <- Config.Reader.read_imports!(path),
         {manifest_kwlist, other_config} <- Keyword.pop!(config, :harness),
         %__MODULE__{} = manifest <- struct(__MODULE__, manifest_kwlist),
         {:version, true} <- {:version, version_match?(manifest)} do
      %__MODULE__{manifest | pkg_config: other_config}
    else
      true ->
        path |> Path.join("harness.exs") |> read()

      {:version, false} ->
        Mix.raise(@version_match_msg)
    end
  end

  @doc """
  Loads the manifest onto the project stack and loads dependencies

  By clearing and pushing a fake project onto the `Mix.ProjectStack`, we can
  utilize large parts of the Mix codebase without much hacking or rewriting.

  This function clears the existing stack and pushes a configuration onto it.
  Most of the configuration follows the defaults, but the dependencies are
  read from the harness manifest (`harness.exs`) and the dependency versions
  are locked to `harness.lock`.
  """
  def load(path) do
    manifest = read(path)

    config =
      fake_mix_project()
      |> Keyword.replace!(:deps, manifest.deps)

    :ok = ProjectStack.clear_stack()
    :ok = ProjectStack.push(__MODULE__, config, Path.expand(path))

    deps = Mix.Dep.cached()

    :ok =
      deps
      |> Enum.flat_map(&Mix.Dep.load_paths/1)
      |> Enum.each(&Code.append_path/1)

    deps
    |> Enum.map(fn %Mix.Dep{app: app} -> app end)
    |> Enum.each(&Application.ensure_started/1)
  end

  defp fake_mix_project do
    [
      # this :app part isn't in Mix.Project.default_config/0, but it fixes an
      # error in elixir 1.11+ about needing an :app to access the build path
      # for a mix project
      app: :harness,
      aliases: [],
      build_embedded: false,
      build_per_environment: true,
      build_scm: Mix.SCM.Path,
      config_path: "config/config.exs",
      consolidate_protocols: true,
      default_task: "run",
      deps: [],
      deps_path: "deps",
      elixirc_paths: ["lib"],
      erlc_paths: ["src"],
      erlc_include_path: "include",
      erlc_options: [],
      lockfile: "harness.lock",
      preferred_cli_env: [],
      start_permanent: false
    ]
  end

  defp version_match?(%{manifest_version: nil}), do: false

  defp version_match?(manifest) do
    Version.match?(manifest.manifest_version, version())
  end
end
