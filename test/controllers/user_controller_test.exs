defmodule Healthlocker.UserControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.User
  @valid_attrs %{email: "some content", password: "some content"}
  @invalid_attrs %{}

  test "loads index.html on /users", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Welcome! Get started by adding new content"
  end

# Below tests will be used later when sign up is complete
  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, user_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New user"
  # end

  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, user_path(conn, :create), user: @valid_attrs
  #   assert redirected_to(conn) == user_path(conn, :index)
  #   assert Repo.get_by(User, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, user_path(conn, :create), user: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New user"
  # end

end