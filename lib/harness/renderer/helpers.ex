defmodule Harness.Renderer.Helpers do
  @moduledoc """
  Helper functions for renders

  These functions are accessible inside templates.
  """

  @doc """
  Converts a string or atom into PascalCase

  Makes use of the `Macro.camelize/1` function underneath.
  """
  def pascal(item) when is_binary(item), do: Macro.camelize(item)
  def pascal(item) when is_atom(item), do: item |> to_string |> pascal()

  @doc """
  Either inspects an item or interpolates it.

  If the item is a binary, it is interpolated. Else, it is inspected with
  `Kernel.inspect/2` and then interpolated.
  """
  def inspect_or_interpolate(item) when is_binary(item), do: String.trim(item)
  def inspect_or_interpolate(item), do: Kernel.inspect(item, limit: :infinity)
end
