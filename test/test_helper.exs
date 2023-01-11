# ExUnit.configure formatters: [Beetseek.CLIFormatter, ExUnit.CLIFormatter]
ExUnit.configure(formatters: [Beetseek.CLIFormatter])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Beatseek.Repo, :manual)
