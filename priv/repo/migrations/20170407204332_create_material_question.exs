defmodule Pitanja.Repo.Migrations.CreatePitanja.Materials.Question do
  use Ecto.Migration

  def change do
    create table(:materials_questions) do
      add :question_num, :integer
      add :question, :string
      add :image, :string

      timestamps()
    end

  end
end
