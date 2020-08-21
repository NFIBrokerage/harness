defmodule Harness.Renderer.Helpers do
  @moduledoc """
  Helper functions for renders
  """

  def pascal(item) when is_binary(item), do: Macro.camelize(item)
  def pascal(item) when is_atom(item), do: item |> to_string |> pascal()
end
