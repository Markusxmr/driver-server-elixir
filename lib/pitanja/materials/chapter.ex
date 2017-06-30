defmodule Pitanja.Materials.Chapter do
  use Ecto.Schema

  schema "materials_chapters" do
    field :chapter_num, :integer
    field :name, :string

    has_many :materials_questions, Pitanja.Materials.Question, on_delete: :delete_all

    timestamps()
  end
end
