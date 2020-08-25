defmodule Harness.Renderer do
  @moduledoc false

  # Functions for rendering a harness package into the current directory

  alias Harness.{Manifest, Tree}
  alias Harness.Renderer.{Run, File, Utils}

  def render(path) when is_binary(path) do
    manifest = Manifest.read(path)

    manifest.generators
    |> Enum.map(&Run.source(&1, manifest.opts, path))
    |> Enum.map(&Run.source_files/1)
    |> Enum.map(&Run.expand_paths/1)
    |> Enum.each(&render/1)
  end

  def render(%Run{} = run) do
    run
    |> into_tree()
    |> generate_tree(run)
  end

  defp into_tree(%Run{files: rest}) do
    root = %File{output_path: ".", type: :directory}
    into_tree(rest, {root, _children = []})
  end

  defp into_tree([], {parent, children}), do: {parent, sort(children)}

  defp into_tree([node | rest], {parent, children}) do
    if child?(node, parent) do
      into_tree(
        rest,
        {parent, [into_tree(rest, {node, []}) | children]}
      )
    else
      into_tree(rest, {parent, children})
    end
  end

  defp child?(node, parent) do
    Path.dirname(node.output_path) == parent.output_path
  end

  defp generate_tree(tree, run) do
    {_parent, children} = tree

    root_node = %File{
      output_path: run.output_directory,
      type: :directory,
      root?: true
    }

    Mix.shell().info("==> #{run.generator_name}")

    {time, _return_value} =
      :timer.tc(fn ->
        [{root_node, children}]
        |> Tree.print_tree(&tree_node_callback(&1, run), format: "pretty")
      end)

    Mix.shell().info("""
    Harnessed #{Run.file_composition(run)} in #{Utils.format_time(time)}
    """)
  end

  @spec tree_node_callback({%File{}, [tuple()]}, %Run{}) ::
          {{String.t(), String.t()}, [tuple()]}
  defp tree_node_callback({%File{} = parent, children}, %Run{} = run)
       when is_list(children) do
    {{File.print(parent), File.generate(run, parent)}, children}
  end

  defp sort(children) do
    children
    |> Enum.reverse()
    # puts all the symlinks last
    |> Enum.sort_by(fn {node, _children} -> node.type == :symlink end)
  end

  def clean(path) when is_binary(path) do
    manifest = Manifest.read(path)

    manifest.generators
    |> Enum.map(&Run.source(&1, manifest.opts, path))
    |> Enum.map(&Run.source_files/1)
    |> Enum.map(&Run.expand_paths/1)
    |> Enum.each(&clean/1)

    path
    |> Path.join(".harness")
    |> Elixir.File.rm_rf!()
  end

  def clean(%Run{} = run) do
    run.files
    |> Enum.filter(fn %{type: type} -> type == :symlink end)
    |> Enum.each(&File.remove!/1)
  end
end
