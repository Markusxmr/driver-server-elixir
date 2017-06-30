defmodule Pitanja.Repo.Migrations.CreatePitanja.Materials.Answer do
  use Ecto.Migration

  def change do
    create table(:materials_answers) do
      add :answer, :string
      add :correct, :boolean, default: false, null: false

      timestamps()
    end

  end
end
