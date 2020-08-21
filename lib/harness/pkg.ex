defmodule Harness.Pkg do
  @moduledoc """
  A behaviour for defining harness package modules.

  Harness packages should add a `pkg.exs` to their root directory which
  describes a single module which implements this behaviour.
  """

  @typedoc "A package module's struct"
  @type t :: struct()

  @doc """
  A function to transform incoming opts (in keyword format) into a package's
  struct (`t:t/0`).

  The simplest `cast/1` is like so:

      def cast(opts), do: struct(__MODULE__, opts)
  """
  @callback cast(opts :: Keyword.t()) :: t()

  @doc """
  A list of symlinks to create from the .harness directory to project root.
  """
  @callback links(t()) :: [String.t()]

  defstruct [:path, :module, :config, :files, :name, :links]

  alias Harness.Cache

  def read(name) when is_atom(name) do
    Cache.dir()
    |> Path.join(Atom.to_string(name))
    |> read()
  end

  def read(path) when is_binary(path) do
    if File.dir?(path) do
      path
      |> Path.join("pkg.exs")
      |> read()
    else
      {{:module, module, _, _}, _} = Code.eval_file(path)

      module
    end
  end
end
