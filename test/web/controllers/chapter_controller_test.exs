defmodule Pitanja.Web.ChapterControllerTest do
  use Pitanja.Web.ConnCase

  alias Pitanja.Materials
  alias Pitanja.Materials.Chapter

  @create_attrs %{chapter_num: 1, name: "some name"}
  @update_attrs %{chapter_num: 2, name: "some updated name"}
  @invalid_attrs %{chapter_num: nil, name: nil}

  def fixture(:chapter) do
    {:ok, chapter} = Materials.create_chapter(@create_attrs)
    chapter
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, chapter_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates chapter and renders chapter when data is valid", %{conn: conn} do
    conn = post conn, chapter_path(conn, :create), chapter: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, chapter_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "chapter_num" => 1,
      "name" => "some name"}
  end

  test "does not create chapter and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, chapter_path(conn, :create), chapter: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen chapter and renders chapter when data is valid", %{conn: conn} do
    %Chapter{id: id} = chapter = fixture(:chapter)
    conn = put conn, chapter_path(conn, :update, chapter), chapter: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, chapter_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "chapter_num" => 2,
      "name" => "some updated name"}
  end

  test "does not update chosen chapter and renders errors when data is invalid", %{conn: conn} do
    chapter = fixture(:chapter)
    conn = put conn, chapter_path(conn, :update, chapter), chapter: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen chapter", %{conn: conn} do
    chapter = fixture(:chapter)
    conn = delete conn, chapter_path(conn, :delete, chapter)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, chapter_path(conn, :show, chapter)
    end
  end
end
