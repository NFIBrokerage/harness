defmodule Mix.Tasks.Harness.Update do
  @shortdoc "Updates harness dependencies"
  @moduledoc """
  Updates harness dependencies according to a harness.exs

  This task mimics `mix deps.update` (and uses it for the implementation).
  Any options are passed directly to the invocation of `mix deps.update`
  """

  use Mix.Task

  alias Harness.Manifest

  @impl Mix.Task
  def run(args) do
    path = "."

    Manifest.load(path)

    Mix.Task.run("deps.update", args)
  end
end
