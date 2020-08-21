defmodule <%= @app |> pascal %>Web.VersionController do
  use <%= @app |> pascal %>Web, :controller

  def index(conn, _params) do
    text(conn, <%= @app |> pascal %>.Application.get_version())
  end
end
