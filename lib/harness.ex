defmodule Harness do
  @moduledoc """
  harness the boilerplate!
  """

  def ignore_patterns do
    [
      # ignore vim swapfiles
      ~r"\..*\.swp$",
      ~r"\.elixir_ls"
    ]
  end
end
