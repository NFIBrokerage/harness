# credo:disable-for-this-file Credo.Check.Consistency.ParameterPatternMatching
defmodule Harness.Tree do
  @moduledoc """
  Renders things as a tree

  See the original implementation in Mix
  [here](https://github.com/elixir-lang/elixir/blob/v1.10/lib/mix/lib/mix/utils.ex).

  The original implementation has an optimization for dependency trees which
  prevents showing the same dependency tree twice. That's great for printing
  small dependency trees, but for file trees, we want to see the entire tree
  every time, even if a file or directory name is present many times.

  The changes to the original implementation are shown as comments below:
  """

  @doc """
  Prints the given tree according to the callback.
  The callback will be invoked for each node and it
  must return a `{printed, children}` tuple.
  """
  def print_tree(nodes, callback, opts \\ []) do
    pretty? =
      case Keyword.get(opts, :format) do
        "pretty" -> true
        "plain" -> false
        _other -> elem(:os.type(), 0) != :win32
      end

    print_tree(
      nodes,
      _depth = [],
      _parent = nil,
      _seen = MapSet.new(),
      pretty?,
      callback
    )

    :ok
  end

  defp print_tree(_nodes = [], _depth, _parent, seen, _pretty, _callback) do
    seen
  end

  defp print_tree([node | nodes], depth, parent, seen, pretty?, callback) do
    {{name, info}, children} = callback.(node)
    # removed
    # key = {parent, name}

    info = if(info, do: " #{info}", else: "")

    Mix.shell().info(
      "#{depth(pretty?, depth)}#{prefix(pretty?, depth, nodes)}#{name}#{info}"
    )

    seen =
      print_tree(
        children,
        [nodes != [] | depth],
        name,
        # switched this next line (51) for the next (52)
        seen,
        # MapSet.put(seen, key),
        pretty?,
        callback
      )

    print_tree(nodes, depth, parent, seen, pretty?, callback)
  end

  defp depth(_pretty?, []), do: ""

  defp depth(pretty?, depth),
    do: Enum.reverse(depth) |> tl |> Enum.map(&entry(pretty?, &1))

  defp entry(false, true), do: "|   "
  defp entry(false, false), do: "    "
  defp entry(true, true), do: "│   "
  defp entry(true, false), do: "    "

  defp prefix(false, [], _), do: ""
  defp prefix(false, _, []), do: "`-- "
  defp prefix(false, _, _), do: "|-- "
  defp prefix(true, [], _), do: ""
  defp prefix(true, _, []), do: "└── "
  defp prefix(true, _, _), do: "├── "
end
