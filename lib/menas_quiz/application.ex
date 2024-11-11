defmodule MenasQuiz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MenasQuizWeb.Telemetry,
      MenasQuiz.Repo,
      {DNSCluster, query: Application.get_env(:menas_quiz, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MenasQuiz.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MenasQuiz.Finch},
      # Start a worker by calling: MenasQuiz.Worker.start_link(arg)
      # {MenasQuiz.Worker, arg},
      # Start to serve requests, typically the last entry
      MenasQuizWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MenasQuiz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MenasQuizWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
