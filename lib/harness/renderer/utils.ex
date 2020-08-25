defmodule Harness.Renderer.Utils do
  @moduledoc false

  alias IO.ANSI

  # generally useful functions for rendering

  @doc """
  Formats a native time into a human readable format

  Most times will be in the µs range because file operations are kinda slow.
  A generator would have to be fairly large and a computer fairly slow to start
  reaching the ms range.

  A run of the current micro controller harness yields 137µs from scratch and
  ~105µs when re-harnessing.
  """
  def format_time(native_time) do
    System.convert_time_unit(native_time, :native, :nanosecond)
    |> format_time_to_string()
  end

  defp format_time_to_string(ns) when ns in 1..1_000 do
    Integer.to_string(ns) <> " ns"
  end

  defp format_time_to_string(ns) when ns in 1_001..1_000_000 do
    us = System.convert_time_unit(ns, :nanosecond, :microsecond)
    Integer.to_string(us) <> " µs"
  end

  defp format_time_to_string(ns) when ns in 1_000_001..1_000_000_000 do
    ms = System.convert_time_unit(ns, :nanosecond, :millisecond)
    Integer.to_string(ms) <> " ms"
  end

  # def green(_text), do: ANSI.green() <> "done" <> ANSI.reset()
  def green(_text), do: ""
  def yellow(text), do: ANSI.yellow() <> "* " <> text <> ANSI.reset()

  def bright_cyan(text),
    do: ANSI.cyan() <> ANSI.bright() <> text <> ANSI.reset()

  def bold_blue(text), do: ANSI.blue() <> ANSI.bright() <> text <> ANSI.reset()

  def count_composition(files) do
    initial = %{
      directory: 0,
      regular: 0,
      symlink: 0
    }

    Enum.reduce(files, initial, fn %{type: type}, acc ->
      Map.update!(acc, type, &(&1 + 1))
    end)
  end

  def format_composition(composition) do
    composition
    |> Enum.map(&format_file_kind/1)
    |> Enum.reject(&is_nil/1)
    |> join_compositions()
  end

  defp format_file_kind({_type, 0}), do: nil
  defp format_file_kind({:regular, 1}), do: "1 file"
  defp format_file_kind({:symlink, 1}), do: "1 link"
  defp format_file_kind({:directory, 1}), do: "1 directory"
  defp format_file_kind({:regular, count}), do: "#{count} files"
  defp format_file_kind({:symlink, count}), do: "#{count} links"
  defp format_file_kind({:directory, count}), do: "#{count} directories"

  defp join_compositions([kind]), do: kind
  defp join_compositions([kind_a, kind_b]), do: kind_a <> " and " <> kind_b

  defp join_compositions([kind_a, kind_b, kind_c]) do
    "#{kind_a}, #{kind_b}, and #{kind_c}"
  end
end
