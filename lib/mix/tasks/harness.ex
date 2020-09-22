defmodule Mix.Tasks.Harness do
  @shortdoc "renders harness packages into the current directory"
  @moduledoc """
  Renders harness packages into the current directory

  Configuration of which files to generate and link is according to the current
  directory's harness manifest (`harness.exs`).
  """

  use Mix.Task

  alias Harness.{Manifest, Renderer}

  @impl Mix.Task
  def run(_args) do
    path = "."

    Mix.Task.run("harness.compile", [path])

    Manifest.load(path)

    Renderer.render(path)
  end
end
