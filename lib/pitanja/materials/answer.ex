defmodule Pitanja.Materials.Answer do
  use Ecto.Schema

  schema "materials_answers" do
    field :answer, :string
    field :correct, :boolean, default: false

    belongs_to :question, Pitanja.Materials.Question, foreign_key: :question_id

    timestamps()
  end
end
