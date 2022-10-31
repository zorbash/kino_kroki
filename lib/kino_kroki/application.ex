defmodule Kino.Kroki.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(Kino.KrokiSmartcell)

    Supervisor.start_link([], strategy: :one_for_one, name: KinoDB.Supervisor)
  end
end
