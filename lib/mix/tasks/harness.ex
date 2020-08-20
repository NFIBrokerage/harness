defmodule Mix.Tasks.Harness do
  use Mix.Task

  @switches []

  @impl Mix.Task
  def run(args) do
    OptionParser.parse(args, switches: @switches)
    |> inspect()
    |> Mix.shell().info()
  end
end
