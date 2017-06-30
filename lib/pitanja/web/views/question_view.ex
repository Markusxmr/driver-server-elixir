defmodule Pitanja.Web.QuestionView do
  use Pitanja.Web, :view
  alias Pitanja.Web.{QuestionView, QuestionImage}

  def render("index.json", %{questions: questions}) do
    %{data: render_many(questions, QuestionView, "question.json")}
  end

  def render("show.json", %{question: question}) do
    %{data: render_one(question, QuestionView, "question.json")}
  end

  def render("question.json", %{question: question}) do
    %{id: question.id,
      chapter_id: question.materials_chapter.id,
      question_num: question.question_num,
      question: question.question,
      image: "#{QuestionImage.custom_url}#{QuestionImage.url({question.image, question})}"}
  end
end
