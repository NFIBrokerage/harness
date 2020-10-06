defmodule Harness.MixProject do
  use Mix.Project

  @version_file Path.join(__DIR__, ".version")
  @external_resource @version_file

  def project do
    [
      app: :harness,
      version: version() || "0.0.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        credo: :test,
        coveralls: :test,
        "coveralls.html": :test,
        bless: :test,
        test: :test
      ],
      test_coverage: [tool: ExCoveralls],
      package: package(),
      description: description(),
      source_url: "https://github.com/NFIBrokerage/harness",
      name: "Harness",
      docs: docs()
    ]
  end

  defp version do
    Regex.run(
      ~r/^v([\d\.]+)/,
      File.read!(@version_file),
      capture: :all_but_first
    )
    |> List.wrap()
    |> List.first()
  end

  defp elixirc_paths(:test), do: ["lib", "test/fixtures"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:eex]
    ]
  end

  defp deps do
    [
      # docs
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      # test
      {:bless, "~> 1.0", only: :test},
      {:convene, "~> 0.2", organization: "cuatro", only: :test},
      {:excoveralls, "~> 0.7", only: :test}
    ]
  end

  defp package do
    [
      name: "harness",
      files: ~w(lib .formatter.exs mix.exs README.md .version),
      licenses: [],
      links: %{"GitHub" => "https://github.com/NFIBrokerage/harness"}
    ]
  end

  defp description do
    "A command line tool for harnessing Elixir boilerplate"
  end

  defp docs do
    [
      deps: [],
      extras: [
        "CHANGELOG.md",
        "guides/Welcome.md",
        "guides/About.md",
        "guides/Getting Started.md",
        "guides/Manifests.md"
      ],
      groups_for_extras: [
        Guides: Path.wildcard("guides/*.md")
      ]
    ]
  end
end
