defmodule Pitanja.Web.AnswerController do
  use Pitanja.Web, :controller

  alias Pitanja.Materials
  alias Pitanja.Materials.Answer

  action_fallback Pitanja.Web.FallbackController

  def index(conn, _params) do
    answers = Materials.list_answers()
    render(conn, "index.json", answers: answers)
  end

  def list_answers_by_question_id(conn, %{"id" => id}) do
    answers = Materials.list_answers_by_question_id(id)
    render(conn, "index.json", answers: answers)
  end

  def create(conn, %{"answer" => answer_params}) do
    with {:ok, %Answer{} = answer} <- Materials.create_answer(answer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", answer_path(conn, :show, answer))
      |> render("show.json", answer: answer)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = Materials.get_answer!(id)
    render(conn, "show.json", answer: answer)
  end

  def update(conn, %{"id" => id, "answer" => answer_params}) do
    answer = Materials.get_answer!(id)

    with {:ok, %Answer{} = answer} <- Materials.update_answer(answer, answer_params) do
      render(conn, "show.json", answer: answer)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Materials.get_answer!(id)
    with {:ok, %Answer{}} <- Materials.delete_answer(answer) do
      send_resp(conn, :no_content, "")
    end
  end
end
