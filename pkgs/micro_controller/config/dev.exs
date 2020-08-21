import Config

config :<%= @app %>, <%= @app |> pascal %>Web.Endpoint,
       http: [port: 4000],
       debug_errors: true,
       code_reloader: true,
       check_origin: false

config :<%= @app %>,
       <%= @app |> pascal %>Web.Endpoint,
       live_reload: [
         patterns: [
           ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
           ~r"priv/gettext/.*(po)$",
           ~r"lib/<%= @app %>_web/(live|views)/.*(ex)$",
           ~r"lib/<%= @app %>_web/templates/.*(eex)$"
         ]
       ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :liquorice,
  sdk_key: System.get_env("LAUNCH_DARKLY_SDK_KEY")
