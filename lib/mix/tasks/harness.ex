defmodule Mix.Tasks.Harness do
  @shortdoc "renders harness packages into the current directory"
  @moduledoc """
  Renders harness packages into the current directory

  Configuration of which files to generate and link is according to the current
  directory's harness manifest (`harness.exs`).

  ## Command line options

    * `--no-compile` - skips the compilation of harness packages
    * `--no-deps-check` - skips a check for out of date dependencies
  """

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    path = "."

    Mix.Task.run("harness.loadpaths", args)

    # this is redundant past elixir 1.11+, can be removed when harness
    # requires that as a minimum
    unless "--no-compile" in args do
      Mix.Task.run("harness.compile", [path])
    end

    Harness.Renderer.render(path)
  end
end
