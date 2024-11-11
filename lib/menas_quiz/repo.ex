defmodule MenasQuiz.Repo do
  use Ecto.Repo,
    otp_app: :menas_quiz,
    adapter: Ecto.Adapters.Postgres
end
