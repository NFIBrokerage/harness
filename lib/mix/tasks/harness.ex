defmodule Mix.Tasks.Harness do
  @shortdoc "Generates harness packages into a path"
  @moduledoc """
  Generates harness packages into the specified path

  Configuration of which files to generate and link is according to the path's
  harness manifest (`harness.exs`).
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
