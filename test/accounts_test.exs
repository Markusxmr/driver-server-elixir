defmodule Pitanja.AccountsTest do
  use Pitanja.DataCase

  alias Pitanja.Accounts
  alias Pitanja.Accounts.User

  @create_attrs %{avatar: "some avatar", dob: "some dob", email: "some email", encrypted_password: "some encrypted_password", first_name: "some first_name", last_name: "some last_name", role: "some role"}
  @update_attrs %{avatar: "some updated avatar", dob: "some updated dob", email: "some updated email", encrypted_password: "some updated encrypted_password", first_name: "some updated first_name", last_name: "some updated last_name", role: "some updated role"}
  @invalid_attrs %{avatar: nil, dob: nil, email: nil, encrypted_password: nil, first_name: nil, last_name: nil, role: nil}

  def fixture(:user, attrs \\ @create_attrs) do
    {:ok, user} = Accounts.create_user(attrs)
    user
  end

  test "list_users/1 returns all users" do
    user = fixture(:user)
    assert Accounts.list_users() == [user]
  end

  test "get_user! returns the user with given id" do
    user = fixture(:user)
    assert Accounts.get_user!(user.id) == user
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Accounts.create_user(@create_attrs)
    assert user.avatar == "some avatar"
    assert user.dob == "some dob"
    assert user.email == "some email"
    assert user.encrypted_password == "some encrypted_password"
    assert user.first_name == "some first_name"
    assert user.last_name == "some last_name"
    assert user.role == "some role"
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = fixture(:user)
    assert {:ok, user} = Accounts.update_user(user, @update_attrs)
    assert %User{} = user
    assert user.avatar == "some updated avatar"
    assert user.dob == "some updated dob"
    assert user.email == "some updated email"
    assert user.encrypted_password == "some updated encrypted_password"
    assert user.first_name == "some updated first_name"
    assert user.last_name == "some updated last_name"
    assert user.role == "some updated role"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = fixture(:user)
    assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    assert user == Accounts.get_user!(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = fixture(:user)
    assert {:ok, %User{}} = Accounts.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = fixture(:user)
    assert %Ecto.Changeset{} = Accounts.change_user(user)
  end
end
