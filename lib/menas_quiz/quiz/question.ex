defmodule MenasQuiz.Quiz.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :question, :string
    # Keep as a string for database storage
    field :answers, :string
    field :solution_id, :string

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question, :answers, :solution_id])
    |> validate_required([:question, :answers, :solution_id])
  end

  # Add a function to parse `answers` as JSON when loading:
  def get_answers_as_map(%{answers: answers}) when is_binary(answers) do
    case Jason.decode(answers) do
      {:ok, decoded} -> decoded
      _ -> []
    end
  end
end
