defmodule MenasQuiz.Quiz do
  @moduledoc """
  The Quiz context.
  """

  import Ecto.Query, warn: false
  alias MenasQuiz.Repo

  alias MenasQuiz.Quiz.Question
  alias MenasQuiz.Quiz.OpenAI

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
    |> Question.changeset(attrs)
    |> Repo.insert()
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
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{data: %Question{}}

  """
  def change_question(%Question{} = question, attrs \\ %{}) do
    Question.changeset(question, attrs)
  end

  def get_questions(previous_questions) do
    previous_questions_message =
      Enum.map_join(previous_questions, "\n", fn question ->
        "Previously asked: \"#{question}\""
      end)

    previous_prompt = """
    Here are the questions you have already asked:
    #{previous_questions_message}
    """

    case OpenAI.fetch_quiz_question(previous_prompt) do
      {:ok, %LangChain.Message{content: content}} ->
        case Jason.decode(content) do
          {:ok, %{"questions" => questions}} when is_list(questions) ->
            parsed_questions =
              Enum.map(questions, fn question ->
                %{
                  "question" => question_text,
                  "answers" => answers,
                  "solutionId" => solution_id
                } = question

                %{
                  question: question_text,
                  answers: answers,
                  solution_id: solution_id
                }
              end)

            %{questions: parsed_questions}

          {:error, _reason} ->
            IO.inspect(content, label: "Failed to parse the response content")
            %{error: "Failed to parse the response from the API"}
        end

      {:error, _reason} ->
        %{error: "Failed to fetch a question from the API"}
    end
  end
end
