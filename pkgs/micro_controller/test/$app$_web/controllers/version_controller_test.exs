defmodule <%= @app |> pascal %>Web.VersionControllerTest do
  use <%= @app |> pascal %>Web.ConnCase

  @moduletag :capture_log

  test "GET version returns the version provided by the release_handler", c do
    conn = get(c.conn, Routes.version_path(c.conn, :index))
    assert text_response(conn, :ok) === "v0.0.0-fakeversion"
  end
end
