defmodule <%= @app |> pascal %>Web.Router do
  use <%= @app |> pascal %>Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    get "/version", <%= @app |> pascal %>Web.VersionController, :index

    forward "/", <%= @forward_to %>
  end
end
