defmodule <%= @app |> pascal %>.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Hummingbird.Telemetry,
      <%= @app |> pascal %>Web.Endpoint
    ]

    opts = [
      strategy: :one_for_one,
      name: <%= @app |> pascal %>.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    <%= @app |> pascal %>Web.Endpoint.config_change(
      changed,
      removed
    )

    :ok
  end

  @doc """
  Returns the current app version fetched from :release_handler (or in
  dev/test, a mocked rendition of it).
  """
  if Mix.env() == :prod do
    def get_version do
      [{_app_name, version, _, :permanent}] =
        :release_handler.which_releases()

      to_string(version)
    end
  else
    def get_version, do: "v0.0.0-fakeversion"
  end
end
