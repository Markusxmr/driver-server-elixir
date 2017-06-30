defmodule Pitanja.Materials.Question do
  use Ecto.Schema

  schema "materials_questions" do
    field :question_num, :integer
    field :question, :string
    field :image, Pitanja.Web.QuestionImage.Type

    has_many :answers, Pitanja.Materials.Answer, on_delete: :delete_all
    belongs_to :materials_chapter, Pitanja.Materials.Chapter, foreign_key: :chapter_id

    timestamps()
  end
end
