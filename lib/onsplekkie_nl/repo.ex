defmodule OnsplekkieNl.Repo do
  use Ecto.Repo,
    otp_app: :onsplekkie_nl,
    adapter: Ecto.Adapters.Postgres
end
