defmodule Mix.Tasks.Harness.Check do
  @shortdoc "checks that the generated harness files are up to date"
  @moduledoc """
  Checks that the `.harness` directory is up-to-date with the manifest
  """
  @moduledoc since: "0.6.0"

  use Mix.Task

  alias Harness.Manifest

  @impl Mix.Task
  def run(_args) do
    path = "."

    case Manifest.verify(path) do
      :ok ->
        :ok

      {:error, _reason} ->
        Mix.raise("The .harness directory is out of date. Run 'mix harness'")
    end
  end
end
