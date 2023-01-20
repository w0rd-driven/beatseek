defmodule Beatseek.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BeatseekWeb.Telemetry,
      # Start the Ecto repository
      Beatseek.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Beatseek.PubSub},
      # Start Finch
      {Finch, name: Beatseek.Finch},
      # Start the Endpoint (http/https)
      BeatseekWeb.Endpoint,
      # Start a worker by calling: Beatseek.Worker.start_link(arg)
      # {Beatseek.Worker, arg}
      # Added Oban
      {Oban, Application.fetch_env!(:beatseek, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Beatseek.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BeatseekWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
