defmodule HelloPheonix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HelloPheonix.Repo,
      # Start the Telemetry supervisor
      HelloPheonixWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HelloPheonix.PubSub},
      # Start the Endpoint (http/https)
      HelloPheonixWeb.Endpoint
      # Start a worker by calling: HelloPheonix.Worker.start_link(arg)
      # {HelloPheonix.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloPheonix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelloPheonixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
