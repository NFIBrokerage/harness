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
  @callback links(t()) :: [Path.t()]

  @doc """
  A list of hard links to create from the .harness directory to project root.
  """
  @callback hard_links(t()) :: [String.t()]

  defstruct [:path, :module, :config, :files, :name, :links, :hard_links]

  def path(generator) do
    otp_app = otp_app(generator)

    Mix.Dep.cached()
    |> Enum.find(fn %Mix.Dep{app: app} -> app == otp_app end)
    |> Map.fetch!(:opts)
    |> Keyword.fetch!(:dest)
    |> Path.join("templates")
  end

  def otp_app(generator) do
    case :application.get_application(generator) do
      {:ok, otp_app} ->
        otp_app

      :undefined ->
        Mix.raise(
          "Could not determine the otp app for " <>
            inspect(generator) <>
            ".\n" <>
            "You may need to fetch dependencies with \"mix harness.get\""
        )
    end
  end
end
