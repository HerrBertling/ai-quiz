defmodule MenasQuizWeb.QuestionLive.Index do
  use MenasQuizWeb, :live_view

  alias MenasQuiz.Quiz

  @impl true
  def mount(_params, _session, socket) do
    result = Quiz.get_questions([])

    socket =
      socket
      |> assign(:quiz_state, "idle")
      |> assign(:selected_answer_id, nil)
      |> assign(:current_question_index, 0)
      |> assign(:asked_questions, [])

    case result do
      %{questions: questions} ->
        socket =
          socket
          |> assign(:asked_questions, Enum.map(questions, & &1.question))
          |> assign(:questions, questions)
          |> assign(:current_question, hd(questions))

        {:ok, socket}

      %{error: error_message} ->
        {:ok, put_flash(socket, :error, error_message)}
    end
  end

  @impl true
  def handle_event("new_question", _params, socket) do
    result = Quiz.get_questions(socket.assigns.asked_questions)

    socket =
      socket
      |> assign(:quiz_state, "idle")
      |> assign(:selected_answer_id, nil)
      |> assign(:current_question_index, 0)

    case result do
      %{questions: questions} ->
        appended_asked_questions =
          socket.assigns.asked_questions ++ Enum.map(questions, & &1.question)

        socket =
          socket
          |> assign(:asked_questions, appended_asked_questions)
          |> assign(:questions, questions)
          |> assign(:current_question, hd(questions))

        {:noreply, socket}

      %{error: error_message} ->
        {:noreply, put_flash(socket, :error, error_message)}
    end
  end

  @impl true
  def handle_event("next_question", _params, socket) do
    next_index = socket.assigns.current_question_index + 1

    if next_index < length(socket.assigns.questions) do
      next_question = Enum.at(socket.assigns.questions, next_index)

      socket =
        socket
        |> assign(:current_question_index, next_index)
        |> assign(:current_question, next_question)
        |> assign(:quiz_state, "idle")
        |> assign(:selected_answer_id, nil)

      {:noreply, socket}
    else
      socket =
        socket
        |> assign(:quiz_state, "finished")

      {:noreply, socket}
    end
  end

  def handle_event("submit_answer", %{"answer" => answer}, socket) do
    quiz_state =
      if answer == socket.assigns.current_question.solution_id, do: "correct", else: "wrong"

    socket =
      socket
      |> assign(:selected_answer_id, answer)
      |> assign(:quiz_state, quiz_state)

    {:noreply, socket}
  end
end
