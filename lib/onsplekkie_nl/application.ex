defmodule OnsplekkieNl.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OnsplekkieNlWeb.Telemetry,
      OnsplekkieNl.Repo,
      {DNSCluster, query: Application.get_env(:onsplekkie_nl, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: OnsplekkieNl.PubSub},
      # Start a worker by calling: OnsplekkieNl.Worker.start_link(arg)
      # {OnsplekkieNl.Worker, arg},
      # Start to serve requests, typically the last entry
      OnsplekkieNlWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OnsplekkieNl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OnsplekkieNlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
