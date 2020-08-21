import Config

config :<%= @app %>, <%= @app |> pascal %>Web.Endpoint,
       http: [port: 4001],
       server: false

config :logger, level: :warn
