defmodule LiveViewCollectionWeb.PageControllerTest do
  use LiveViewCollectionWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Phoenix LiveView Collection"
  end
end
