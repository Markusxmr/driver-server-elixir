defmodule Pitanja.Materials do
  @moduledoc """
  The boundary for the Materials system.
  """

  import Ecto.{Query, Changeset}, warn: false

  use Arc.Ecto.Schema, only: [cast_attachments: 3]

  alias Pitanja.Repo

  alias Pitanja.Materials.Chapter

  @doc """
  Returns the list of chapters.

  ## Examples

      iex> list_chapters()
      [%Chapter{}, ...]

  """
  def list_chapters do
    Repo.all(Chapter)
  end

  @doc """
  Gets a single chapter.

  Raises `Ecto.NoResultsError` if the Chapter does not exist.

  ## Examples

      iex> get_chapter!(123)
      %Chapter{}

      iex> get_chapter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chapter!(id), do: Repo.get!(Chapter, id)

  @doc """
  Creates a chapter.

  ## Examples

      iex> create_chapter(%{field: value})
      {:ok, %Chapter{}}

      iex> create_chapter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chapter(attrs \\ %{}) do
    %Chapter{}
    |> chapter_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chapter.

  ## Examples

      iex> update_chapter(chapter, %{field: new_value})
      {:ok, %Chapter{}}

      iex> update_chapter(chapter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chapter(%Chapter{} = chapter, attrs) do
    chapter
    |> chapter_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Chapter.

  ## Examples

      iex> delete_chapter(chapter)
      {:ok, %Chapter{}}

      iex> delete_chapter(chapter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chapter(%Chapter{} = chapter) do
    Repo.delete(chapter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chapter changes.

  ## Examples

      iex> change_chapter(chapter)
      %Ecto.Changeset{source: %Chapter{}}

  """
  def change_chapter(%Chapter{} = chapter) do
    chapter_changeset(chapter, %{})
  end

  defp chapter_changeset(%Chapter{} = chapter, attrs) do
    chapter
    |> cast(attrs, [:chapter_num, :name])
    |> validate_required([:chapter_num, :name])
  end

  alias Pitanja.Materials.Question

  @doc """
  Preloads Question Chapter
  """

  def preload_question(question) do
    question |> Repo.preload(:materials_chapter)
  end

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question)
  end

  @doc """
  Returns the list of questions.

  ## Examples

  """
  def list_questions_by_chapter_id(id) do
    Repo.all(from q in Question,
    where: q.chapter_id == ^id,
    select: q)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> question_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Adds a question image

  ##Examples

      iex> create_question_image(question, %{field: new_value})
      {:ok, %Question{}}
  """

  def create_question_image(%Question{} = question, attrs) do
      question
      |> question_image_changeset(%{chapter_id: question.chapter_id, image: attrs})
      |> Repo.update()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> question_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    case File.exists?("uploads/question_images/#{question.id}") do
      true ->
        File.rm_rf!("uploads/question_images/#{question.id}")
      false ->
        :error
    end

    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{source: %Question{}}

  """
  def change_question(%Question{} = question) do
    question_changeset(question, %{})
  end

  defp question_changeset(%Question{} = question, attrs) do
    question
    |> cast(attrs, [:question_num, :question, :chapter_id])
    |> validate_required([:question])
    |> foreign_key_constraint(:chapter_id)
  end

  def question_image_changeset(%Question{} = question, attrs) do
    question
    |> cast_attachments(attrs, [:image])
    |> validate_required([:image])
    |> foreign_key_constraint(:chapter_id)
  end

  alias Pitanja.Materials.Answer

  @doc """
  Returns the list of answers.

  ## Examples

      iex> list_answers()
      [%Answer{}, ...]

  """
  def list_answers do
    Repo.all(Answer)
  end

  def list_answers_by_question_id(id) do
    Repo.all(from a in Answer,
      where: a.question_id == ^id,
      select: a)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> answer_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> answer_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{source: %Answer{}}

  """
  def change_answer(%Answer{} = answer) do
    answer_changeset(answer, %{})
  end

  defp answer_changeset(%Answer{} = answer, attrs) do
    answer
    |> cast(attrs, [:answer, :correct, :question_id])
    |> validate_required([:answer, :correct])
    |> foreign_key_constraint(:question_id)
  end
end
