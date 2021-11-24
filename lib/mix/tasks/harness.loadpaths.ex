defmodule Mix.Tasks.Harness.Loadpaths do
  @shortdoc "Checks, compiles, and loads all harness packages"
  @moduledoc """
  Checks, compiles, and loads all harness packages

  ## Command line options

    * `--no-compile` - skips the compilation of harness packages
    * `--no-deps-check` - skips a check for out of date dependencies
  """

  # the upstream of this code is here: https://github.com/elixir-lang/elixir/blob/58518794306c70204de14f9ed214fb7f296769d9/lib/mix/lib/mix/tasks/deps.loadpaths.ex
  # this code should be considered copyright the Elixir Core Team

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    path = "."

    Harness.Manifest.load(path)

    unless "--no-deps-check" in args do
      Mix.Dep.load_and_cache()
      |> deps_check("--no-compile" in args)
    end
  end

  defp deps_check(deps, no_compile?) do
    deps = Enum.map(deps, &Mix.Dep.check_lock/1)
    {not_ok, compile} = partition(deps, [], [])

    cond do
      not_ok != [] ->
        show_not_ok!(not_ok)

      compile == [] or no_compile? ->
        :ok

      true ->
        Mix.Tasks.Deps.Compile.compile(compile)
        |> Enum.map(& &1.app)
        |> Mix.Dep.filter_by_name(Mix.Dep.load_and_cache())
        |> Enum.filter(&(not Mix.Dep.ok?(&1)))
        |> show_not_ok!
    end
  end

  defp partition([dep | deps], not_ok, compile) do
    cond do
      Mix.Dep.compilable?(dep) or
          (Mix.Dep.ok?(dep) and dep.scm.fetchable? == false) ->
        if dep.opts[:from_umbrella] do
          partition(deps, not_ok, compile)
        else
          partition(deps, not_ok, [dep | compile])
        end

      Mix.Dep.ok?(dep) ->
        partition(deps, not_ok, compile)

      true ->
        partition(deps, [dep | not_ok], compile)
    end
  end

  defp partition([], not_ok, compile) do
    {Enum.reverse(not_ok), Enum.reverse(compile)}
  end

  defp show_not_ok!([]) do
    :ok
  end

  defp show_not_ok!(deps) do
    shell = Mix.shell()
    shell.error("Unchecked dependencies for environment #{Mix.env()}:")

    Enum.each(deps, fn dep ->
      shell.error("* #{Mix.Dep.format_dep(dep)}")
      shell.error("  #{format_status(dep)}")
    end)

    Mix.raise("Can't continue due to errors on dependencies")
  end

  defp format_status(mix_dep) do
    mix_dep
    |> Mix.Dep.format_status()
    |> String.replace(~r/mix deps.get/, "mix harness.get")
    |> String.replace(~r/mix deps.compile/, "mix harness.compile")
    |> String.replace(~r/mix.lock/, "harness.lock")
  end
end
