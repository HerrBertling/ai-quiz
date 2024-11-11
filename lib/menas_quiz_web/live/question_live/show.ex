defmodule MenasQuizWeb.QuestionLive.Show do
  use MenasQuizWeb, :live_view

  alias MenasQuiz.Quiz

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:question, Quiz.get_question!(id))}
  end

  defp page_title(:show), do: "Show Question"
  defp page_title(:edit), do: "Edit Question"
end
