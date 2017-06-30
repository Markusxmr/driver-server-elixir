# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pitanja.Repo.insert!(%Pitanja.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pitanja.Repo
alias Pitanja.Materials
alias Pitanja.Materials.{Chapter, Question, Answer}

chapters =[
  %Chapter{name: "Propisi u cestovnom prometu"}
]

for chapter <- chapters do
  Repo.get_by(Chapter, name: chapter.name)
  ||
  Repo.insert(chapter)
end

questions = [
  %Question{question: "Što je kolnik?", image: ""}
]

answers = [
  %Answer{
    answer: "dio cestovne površine namijenjen u prvom redu za promet vozila, s
    jednom prometom trakom ili više prometnih traka",
    correct: true
  },
  %Answer{
    answer: "dio cestovne površine namijenjen u prvom redu za promet pješaka, s
    jednom pješačkom stazom ili više pješačkih staza",
    correct: false
  }
]
