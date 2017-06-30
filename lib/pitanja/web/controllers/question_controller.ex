defmodule Pitanja.Web.QuestionController do
  use Pitanja.Web, :controller

  alias Pitanja.Materials
  alias Pitanja.Materials.Question

  action_fallback Pitanja.Web.FallbackController

  def index(conn, _params) do
    questions = Materials.list_questions()
    render(conn, "index.json", questions: questions |> Materials.preload_question())
  end

  def list_questions_by_chapter_id(conn, %{"id" => id}) do
    questions = Materials.list_questions_by_chapter_id(id)
    render(conn, "index.json", questions: questions |> Materials.preload_question())
  end

  def create(conn, %{"question" => question_params}) do
    with {:ok, %Question{} = question} <- Materials.create_question(question_params) do
      question =
        question |> Materials.preload_question()
      conn
      |> put_status(:created)
      |> put_resp_header("location", question_path(conn, :show, question))
      |> render("show.json", question: question)
    end
  end

  def upload_image(conn, %{"id" => question_id, "files" => files}) do
    question = Materials.get_question!(question_id)
    with {:ok, %Question{} = question} <- Materials.create_question_image(question, files) do
      question = question |> Materials.preload_question()
      conn
      |> render("show.json", question: question)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Materials.get_question!(id) |> Materials.preload_question()
    render(conn, "show.json", question: question)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Materials.get_question!(id)

    with {:ok, %Question{} = question} <- Materials.update_question(question, question_params) do
      render(conn, "show.json", question: question |> Materials.preload_question())
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Materials.get_question!(id)
    with {:ok, %Question{}} <- Materials.delete_question(question) do
      #send_resp(conn, :no_content, "")
      render(conn, "show.json", question: question |> Materials.preload_question())
    end
  end
end
