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
  def cyan(text), do: ANSI.cyan() <> text <> ANSI.reset()
end
