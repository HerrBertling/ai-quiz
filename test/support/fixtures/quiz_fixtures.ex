defmodule MenasQuiz.QuizFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MenasQuiz.Quiz` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        answers: "some answers",
        question: "some question",
        solution_id: "some solution_id"
      })
      |> MenasQuiz.Quiz.create_question()

    question
  end
end
