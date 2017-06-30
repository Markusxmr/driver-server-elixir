defmodule Pitanja.Repo.Migrations.AddAnswerReferenceToQuestions do
  use Ecto.Migration

  def change do
    alter table(:materials_answers) do
      add :question_id, references(:materials_questions, on_delete: :nothing) 
    end
  end
end
