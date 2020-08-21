defmodule <%= @app |> pascal %>Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :<%= @app %>

  plug PlugHeartbeat, path: "/healthz"

  use Appsignal.Phoenix

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Hummingbird, service_name: "<%= @app %>"

  plug <%= @app |> pascal %>Web.Router
end
