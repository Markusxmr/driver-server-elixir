defmodule Pitanja.MaterialsTest do
  use Pitanja.DataCase

  alias Pitanja.Materials
  alias Pitanja.Materials.Chapter

  @create_attrs %{chapter_num: 1, name: "some name"}
  @update_attrs %{chapter_num: 2, name: "some updated name"}
  @invalid_attrs %{chapter_num: nil, name: nil}

  def fixture(:chapter, attrs \\ @create_attrs) do
    {:ok, chapter} = Materials.create_chapter(attrs)
    chapter
  end

  test "list_chapters/1 returns all chapters" do
    chapter = fixture(:chapter)
    assert Materials.list_chapters() == [chapter]
  end

  test "get_chapter! returns the chapter with given id" do
    chapter = fixture(:chapter)
    assert Materials.get_chapter!(chapter.id) == chapter
  end

  test "create_chapter/1 with valid data creates a chapter" do
    assert {:ok, %Chapter{} = chapter} = Materials.create_chapter(@create_attrs)
    assert chapter.name == "some name"
    assert chapter.chapter_num == 1
  end

  test "create_chapter/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Materials.create_chapter(@invalid_attrs)
  end

  test "update_chapter/2 with valid data updates the chapter" do
    chapter = fixture(:chapter)
    assert {:ok, chapter} = Materials.update_chapter(chapter, @update_attrs)
    assert %Chapter{} = chapter
    assert chapter.name == "some updated name"
    assert chapter.chapter_num == 2
  end

  test "update_chapter/2 with invalid data returns error changeset" do
    chapter = fixture(:chapter)
    assert {:error, %Ecto.Changeset{}} = Materials.update_chapter(chapter, @invalid_attrs)
    assert chapter == Materials.get_chapter!(chapter.id)
  end

  test "delete_chapter/1 deletes the chapter" do
    chapter = fixture(:chapter)
    assert {:ok, %Chapter{}} = Materials.delete_chapter(chapter)
    assert_raise Ecto.NoResultsError, fn -> Materials.get_chapter!(chapter.id) end
  end

  test "change_chapter/1 returns a chapter changeset" do
    chapter = fixture(:chapter)
    assert %Ecto.Changeset{} = Materials.change_chapter(chapter)
  end
end
