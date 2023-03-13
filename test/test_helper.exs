# ExUnit.configure formatters: [Beatseek.CLIFormatter, ExUnit.CLIFormatter]
ExUnit.configure(exclude: [skip: true, integration: true], formatters: [Beatseek.CLIFormatter])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Beatseek.Repo, :manual)
