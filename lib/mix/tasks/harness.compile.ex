defmodule Mix.Tasks.Harness.Compile do
  @shortdoc "Compiles harness dependencies"
  @moduledoc """
  Compiles harness package dependencies

  Loads the current harness manifest, checks to ensure dependencies have been
  feteched, and then compiles harness package files.
  """

  use Mix.Task

  alias Harness.Manifest

  @impl Mix.Task
  def run([]), do: run(["."])

  def run([path]) do
    Manifest.load(path)

    Mix.Task.run("deps.compile", [])
  end
end
