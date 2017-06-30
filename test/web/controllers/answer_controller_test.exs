defmodule Pitanja.Web.AnswerControllerTest do
  use Pitanja.Web.ConnCase

  alias Pitanja.Materials
  alias Pitanja.Materials.{Chapter, Question, Answer}

  @create_attrs %{answer: "some answer", correct: true}
  @update_attrs %{answer: "some updated answer", correct: false}
  @invalid_attrs %{answer: nil, correct: nil}
  @create_attrs_chapter %{chapter_num: 1, name: "some chapter"}
  @create_attrs_question %{question_num: 1, question: "some question"}

  def fixture(:answer) do
    {:ok, answer} = Materials.create_answer(@create_attrs)
    answer
  end

  def fixture(:chapter) do
    {:ok, chapter} = Materials.create_chapter(@create_attrs_chapter)
    chapter
  end

  def fixture(:question) do
    %Chapter{id: id} = fixture(:chapter)

    create_attrs_question = Map.put(@create_attrs_question, :chapter_id, id)
    {:ok, question} = Materials.create_question(create_attrs_question)
    question
  end

  def fixture(:question_answer) do
    %Question{id: id} = fixture(:question)

    create_attrs = Map.put(@create_attrs, :question_id, id)
    {:ok, answer} = Materials.create_answer(create_attrs)
    answer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, answer_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "list all entries by question id", %{conn: conn} do
    %Answer{id: id} = answer = fixture(:question_answer)
    conn = get conn, answer_path(conn, :index), id: id #list_answers_by_question_id
    assert json_response(conn, 200)["data"] == [%{
      "id" => id,
      "question_id" => answer.question_id,
      "answer" => "some answer",
      "correct" => true
    }]
  end

  test "creates answer and renders answer when data is valid", %{conn: conn} do
    conn = post conn, answer_path(conn, :create), answer: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, answer_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "question_id" => nil,
      "answer" => "some answer",
      "correct" => true}
  end

  test "does not create answer and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, answer_path(conn, :create), answer: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen answer and renders answer when data is valid", %{conn: conn} do
    %Answer{id: id} = answer = fixture(:answer)
    conn = put conn, answer_path(conn, :update, answer), answer: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, answer_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "question_id" => answer.question_id,
      "answer" => "some updated answer",
      "correct" => false}
  end

  test "does not update chosen answer and renders errors when data is invalid", %{conn: conn} do
    answer = fixture(:answer)
    conn = put conn, answer_path(conn, :update, answer), answer: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen answer", %{conn: conn} do
    answer = fixture(:answer)
    conn = delete conn, answer_path(conn, :delete, answer)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, answer_path(conn, :show, answer)
    end
  end
end
