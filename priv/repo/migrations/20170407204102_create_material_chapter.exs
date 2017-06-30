defmodule Pitanja.Repo.Migrations.CreatePitanja.Materials.Chapter do
  use Ecto.Migration

  def change do
    create table(:materials_chapters) do
      add :chapter_num, :integer 
      add :name, :string

      timestamps()
    end

  end
end
