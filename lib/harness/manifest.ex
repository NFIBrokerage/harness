defmodule Harness.Manifest do
  @moduledoc """
  A local project's harness configuration
  """

  defstruct generators: [], opts: []

  def read(path) do
    if File.dir?(path) do
      path |> Path.join("harness.exs") |> read()
    else
      {manifest, []} = Code.eval_file(path)

      struct(__MODULE__, manifest)
    end
  end
end
