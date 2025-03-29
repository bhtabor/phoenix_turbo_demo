defmodule PhoenixTurboDemo.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_turbo_demo,
    adapter: Ecto.Adapters.SQLite3
end
