defmodule Pitanja.Accounts.User do
  @moduledoc false
  
  use Ecto.Schema
  import Ecto.Changeset
  alias Pitanja.Accounts.User

  schema "accounts_users" do
    field :username, :string
    field :avatar, :string
    field :dob, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :first_name, :string
    field :last_name, :string
    field :bio, :string
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :username, :email, :password, :bio, :avatar, :role])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password, message: "Zaporka se ne slaže")
    |> unique_constraint(:email, message: "Email je već zauzet")
    |> generate_encrypted_password()
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end
end
