defmodule Beatseek.Repo do
  use Ecto.Repo,
    otp_app: :beatseek,
    adapter: Ecto.Adapters.Postgres
end
