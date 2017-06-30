defmodule Pitanja.Web.ChapterView do
  use Pitanja.Web, :view
  alias Pitanja.Web.ChapterView

  def render("index.json", %{chapters: chapters}) do
    %{data: render_many(chapters, ChapterView, "chapter.json")}
  end

  def render("show.json", %{chapter: chapter}) do
    %{data: render_one(chapter, ChapterView, "chapter.json")}
  end

  def render("chapter.json", %{chapter: chapter}) do
    %{id: chapter.id,
      chapter_num: chapter.chapter_num,
      name: chapter.name}
  end
end
