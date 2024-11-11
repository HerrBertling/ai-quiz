defmodule MenasQuiz.QuizTest do
  use MenasQuiz.DataCase

  alias MenasQuiz.Quiz

  describe "questions" do
    alias MenasQuiz.Quiz.Question

    import MenasQuiz.QuizFixtures

    @invalid_attrs %{question: nil, answers: nil, solution_id: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Quiz.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Quiz.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{question: "some question", answers: "some answers", solution_id: "some solution_id"}

      assert {:ok, %Question{} = question} = Quiz.create_question(valid_attrs)
      assert question.question == "some question"
      assert question.answers == "some answers"
      assert question.solution_id == "some solution_id"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quiz.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{question: "some updated question", answers: "some updated answers", solution_id: "some updated solution_id"}

      assert {:ok, %Question{} = question} = Quiz.update_question(question, update_attrs)
      assert question.question == "some updated question"
      assert question.answers == "some updated answers"
      assert question.solution_id == "some updated solution_id"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Quiz.update_question(question, @invalid_attrs)
      assert question == Quiz.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Quiz.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Quiz.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Quiz.change_question(question)
    end
  end
end
