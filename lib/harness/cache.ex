defmodule Harness.Cache do
  @moduledoc """
  The Cache is a directory containing the harness templates of a package.

  The Cache (uppercase) is a local cache (lowercase) of the pkg registry.
  """

  alias Harness.Pkg

  def dir do
    Mix.Utils.mix_home()
    |> Path.join("harness_cache")
  end

  def clear!, do: dir() |> File.rm_rf!()

  def create!, do: dir() |> File.mkdir_p!()

  def list! do
    dir()
    |> Path.join("*/pkg.exs")
    |> Path.wildcard(match_dot: true)
    |> Enum.map(&Pkg.read/1)
  end

  def cache_pkg!(:local, pkg_name_full) do
    create!()
    pkg_name = Path.basename(pkg_name_full)
    pkg_path = Path.join(dir(), pkg_name)

    File.rm_rf!(pkg_path)
    File.cp_r!(pkg_name_full, pkg_path)
  end
end
