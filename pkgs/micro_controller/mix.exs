defmodule <%= @app |> pascal() %> do
  use Mix.Project

  def project do
    [
      app: :<%= @app %>,
      version: "0.0.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        credo: :test,
        "test.watch": :test,
        dialyzer: :test,
        bless: :test,
        test: :test
      ],
      # special harness configuration
      config_path: ".harness/config/config.exs",
      test_paths: ["test", ".harness/test"]
    ]
  end

  def application do
    [
      mod: {AuthenticationServiceAccessTokenController.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test),
    do: ~w[lib .harness/lib test/support .harness/test/support]

  defp elixirc_paths(_), do: ~w[lib .harness/lib]

  defp deps do
    <%= Kernel.inspect(@dependencies) %>
  end

  defp aliases do
    [
      release: ["distillery.release"]
    ]
  end
end
