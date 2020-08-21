defmodule Mix.Tasks.Harness do
  @shortdoc "Generates harness packages into a path"
  @moduledoc """
  Generates harness packages into the specified path
  
  Configuration of which files to generate and link is according to the path's
  harness manifest (`harness.exs`).
  """

  use Mix.Task

  alias Harness.Renderer

  @impl Mix.Task
  def run([]), do: run(["."])

  def run([path]) do
    Renderer.render(path)
  end
end
