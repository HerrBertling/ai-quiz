defmodule MenasQuiz.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :question, :string
      add :answers, :text
      add :solution_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
