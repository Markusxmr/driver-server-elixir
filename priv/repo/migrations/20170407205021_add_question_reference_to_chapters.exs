defmodule Pitanja.Repo.Migrations.AddQuestionReferenceToChapters do
  use Ecto.Migration

  def change do
    alter table(:materials_questions) do
      add :chapter_id, references(:materials_chapters, on_delete: :nothing)
    end
  end
end
