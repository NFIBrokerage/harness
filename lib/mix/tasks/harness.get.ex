defmodule Mix.Tasks.Harness.Get do
  @shortdoc "Fetches harness dependencies"
  @moduledoc """
  Fetches harness dependencies according to a harness.exs

  Harness dependencies follow the same format and rules as mix dependencies:
  you may use (public/private) hex, git, or local paths, and dependencies may
  be semantically versioned when fetched via hex.
  """

  use Mix.Task

  alias Harness.Manifest

  @impl Mix.Task
  def run(_args) do
    path = "."

    Manifest.load(path)

    Mix.Tasks.Deps.Get.run([])
  end
end
