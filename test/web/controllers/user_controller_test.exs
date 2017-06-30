defmodule Pitanja.Web.UserControllerTest do
  use Pitanja.Web.ConnCase

  alias Pitanja.Accounts
  alias Pitanja.Accounts.User

  @create_attrs %{avatar: "some avatar", dob: "some dob", email: "some email", encrypted_password: "some encrypted_password", first_name: "some first_name", last_name: "some last_name", role: "some role"}
  @update_attrs %{avatar: "some updated avatar", dob: "some updated dob", email: "some updated email", encrypted_password: "some updated encrypted_password", first_name: "some updated first_name", last_name: "some updated last_name", role: "some updated role"}
  @invalid_attrs %{avatar: nil, dob: nil, email: nil, encrypted_password: nil, first_name: nil, last_name: nil, role: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates user and renders user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, user_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "avatar" => "some avatar",
      "dob" => "some dob",
      "email" => "some email",
      "encrypted_password" => "some encrypted_password",
      "first_name" => "some first_name",
      "last_name" => "some last_name",
      "role" => "some role"}
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen user and renders user when data is valid", %{conn: conn} do
    %User{id: id} = user = fixture(:user)
    conn = put conn, user_path(conn, :update, user), user: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, user_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "avatar" => "some updated avatar",
      "dob" => "some updated dob",
      "email" => "some updated email",
      "encrypted_password" => "some updated encrypted_password",
      "first_name" => "some updated first_name",
      "last_name" => "some updated last_name",
      "role" => "some updated role"}
  end

  test "does not update chosen user and renders errors when data is invalid", %{conn: conn} do
    user = fixture(:user)
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen user", %{conn: conn} do
    user = fixture(:user)
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, user)
    end
  end
end
