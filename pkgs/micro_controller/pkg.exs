defmodule Harness.Pkg.MicroController do
  @behaviour Harness.Pkg

  @private_keys [:dependencies, :secret_key_base]
  @enforce_keys [:app, :forward_to]
  defstruct @private_keys ++ @enforce_keys ++ [explicit_dependencies: []]

  @impl Harness.Pkg
  def cast(opts) do
    struct(__MODULE__, opts) |> merge_dependencies()
  end

  @impl Harness.Pkg
  def links(_config) do
    ~w[
      mix.exs
      .credo.exs
      .dockerignore
      .formatter.exs
      .tool-versions
      coveralls.json
      test/test_helper.exs
    ]
  end

  defp merge_dependencies(config) do
    dependencies =
      (config.explicit_dependencies ++ default_dependencies())
      |> Enum.uniq_by(fn dep -> elem(dep, 0) end)


    %{config | dependencies: dependencies, secret_key_base: secret_key_base()}
  end

  defp default_dependencies do
    [
      {:phoenix, "~> 1.5"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:cowlib, "~> 2.8", override: true},
      {:cowboy, "== 2.7.0"},
      {:telemetry, "~> 0.4"},
      {:plug_heartbeat, "~> 1.0"},
      {:hummingbird, "~> 0.0.13"},
      {:appsignal, "~> 1.10"},
      {:liquorice, "~> 0.2", organization: "cuatro", only: [:prod, :dev]},

      # test
      {:bless, "~> 1.0"},
      {:convene, "~> 0.2", organization: "cuatro"},
      {:excoveralls, "~> 0.11", only: :test},
      {:private, "~> 0.1.1"},
      {:faker, "~> 0.8"},
      {:apex, "~> 1.1", only: [:dev, :test]},
      {:mox, "~> 0.5"},

      # release
      {:distillery, "~> 2.1", runtime: false}
    ]
  end

  defp secret_key_base do
    # see phoenix/lib/mix/tasks/phx.gen.secret
    :crypto.strong_rand_bytes(64) |> Base.encode64 |> binary_part(0, 64)
  end
end
