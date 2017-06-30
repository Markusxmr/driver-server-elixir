defmodule Pitanja.Web.QuestionControllerTest do
  use Pitanja.Web.ConnCase

  alias Pitanja.Materials
  alias Pitanja.Materials.{Chapter, Question}

  @create_attrs %{question_num: 1, image: "some image", question: "some question"}
  @update_attrs %{question_num: 2, image: "some updated image", question: "some updated question"}
  @invalid_attrs %{image: nil, question: nil}
  @create_attrs_chapter %{chapter_num: 1, name: "some chapter"}

  def fixture(:question) do
    {:ok, question} = Materials.create_question(@create_attrs)
    question
  end

  def fixture(:chapter) do
    {:ok, chapter} = Materials.create_chapter(@create_attrs_chapter)
    chapter
  end

  def fixture(:question_chapter, %{chapter_id: chapter_id}) do
    create_attrs = Map.put(@create_attrs, :chapter_id, chapter_id)
    {:ok, question} = Materials.create_question(create_attrs)
    question
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, question_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "list entries by chapter id", %{conn: conn} do
    chapter = fixture(:chapter)
    question = fixture(:question_chapter, %{chapter_id: chapter.id})
    conn = get conn, question_path(conn, :list_questions_by_chapter_id, chapter.id)
    assert json_response(conn, 200)["data"] == [
      %{
        "id" => question.id,
        "chapter_id" => chapter.id,
        "question_num" => 1,
        "image" => "http://localhost:4000http://localhost:4000",
        "question" => "some question"
      }
    ]
  end

  test "creates question and renders question when data is valid", %{conn: conn} do
    %Chapter{id: id} = chapter = fixture(:chapter)

    create_attrs = Map.put(@create_attrs, :chapter_id, id)
    conn = post conn, question_path(conn, :create), question: create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, question_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "chapter_id" => chapter.id,
      "question_num" => 1,
      "image" => "http://localhost:4000http://localhost:4000",
      "question" => "some question"}
  end

  test "does not create question and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, question_path(conn, :create), question: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen question and renders question when data is valid", %{conn: conn} do
    chapter = fixture(:chapter)
    %Question{id: id} = question = fixture(:question_chapter, %{chapter_id: chapter.id})
    conn = put conn, question_path(conn, :update, question), question: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, question_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "chapter_id" => chapter.id,
      "question_num" => 2,
      "image" => "http://localhost:4000http://localhost:4000",
      "question" => "some updated question"}
  end

  test "does not update chosen question and renders errors when data is invalid", %{conn: conn} do
    question = fixture(:question)
    conn = put conn, question_path(conn, :update, question), question: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen question", %{conn: conn} do
    chapter = fixture(:chapter)
    question = fixture(:question_chapter, %{chapter_id: chapter.id})
    conn = delete conn, question_path(conn, :delete, question)
    assert json_response(conn, 200)["data"] == %{
      "id" => question.id,
      "chapter_id" => chapter.id,
      "question_num" => 1,
      "image" => "http://localhost:4000http://localhost:4000",
      "question" => "some question"}
    assert_error_sent 404, fn ->
      get conn, question_path(conn, :show, question)
    end
  end
end
