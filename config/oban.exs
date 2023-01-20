import Config

config :beatseek, Oban,
  repo: Beatseek.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]
