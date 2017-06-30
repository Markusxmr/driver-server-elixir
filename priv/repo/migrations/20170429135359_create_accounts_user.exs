defmodule Pitanja.Repo.Migrations.CreatePitanja.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :username, :string
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :dob, :string
      add :avatar, :string
      add :bio, :string
      add :encrypted_password, :string
      add :role, :string

      timestamps()
    end

    create unique_index(:accounts_users, [:email])
  end
end
