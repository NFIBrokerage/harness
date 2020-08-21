import Config

config :<%= @app %>, <%= @app |> pascal() %>Web.Endpoint,
       url: [host: "localhost"],
       secret_key_base:
         "<%= @secret_key_base %>",
       render_errors: [
         view: <%= @app |> pascal %>Web.ErrorView,
         accepts: ~w(html json),
         layout: false
       ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "../../config/config.exs"
