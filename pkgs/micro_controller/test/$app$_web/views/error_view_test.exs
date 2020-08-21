defmodule <%= @app |> pascal %>Web.ErrorViewTest do
  use <%= @app |> pascal %>Web.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render(
             <%= @app |> pascal %>Web.ErrorView,
             "404.json",
             []
           ) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.html" do
    assert render(
             <%= @app |> pascal %>Web.ErrorView,
             "500.json",
             []
           ) == %{errors: %{detail: "Internal Server Error"}}
  end
end
