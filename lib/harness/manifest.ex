defmodule Harness.Manifest do
  @moduledoc """
  A local project's harness configuration
  """

  alias Mix.ProjectStack

  defstruct generators: [], opts: [], deps: [], manifest_version: nil

  @doc false
  def version, do: "~> 0.0.0"

  @doc false
  def manifest_file, do: "harness.exs"

  @doc "reads the manifest file from the path"
  def read(path) do
    with false <- File.dir?(path),
         {:ok, contents} <- File.read(path),
         {manifest, []} <- Code.eval_string(contents) do
      struct(__MODULE__, manifest)
    else
      true = _is_directory ->
        path |> Path.join("harness.exs") |> read()

      _could_not_be_evaluated ->
        Mix.raise(
          "Is there a harness.exs in \"#{Path.dirname(path)}\"? None could be found."
        )
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
end
