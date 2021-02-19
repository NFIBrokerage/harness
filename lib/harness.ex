defmodule Harness do
  @moduledoc """
  harness the boilerplate!
  """
  @moduledoc since: "0.1.0"

  @version Mix.Project.config()[:version]

  @doc since: "0.4.0"
  def version, do: @version

  @doc since: "0.1.0"
  def ignore_patterns do
    [
      # ignore vim swapfiles
      ~r"\..*\.swp$",
      ~r"\.elixir_ls"
    ]
  end
end
