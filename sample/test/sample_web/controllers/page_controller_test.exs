defmodule SampleWeb.PageControllerTest do
  use SampleWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Team-K Framework"
  end
end
