# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :beatseek,
  ecto_repos: [Beatseek.Repo]

# Configures the endpoint
config :beatseek, BeatseekWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: BeatseekWeb.ErrorHTML, json: BeatseekWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Beatseek.PubSub,
  live_view: [signing_salt: "7uA8xa8n"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :beatseek, Beatseek.Mailer, adapter: Swoosh.Adapters.Local

config :beatseek, Oban,
  repo: Beatseek.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

spotify_scopes =
  ~w(
      streaming
      user-read-playback-position
      user-read-private
      user-read-email
      playlist-modify-public
      playlist-modify-private
      playlist-read-public
      playlist-read-private
      user-library-read
      user-library-modify
      user-top-read
      playlist-read-collaborative
      ugc-image-upload
      user-follow-read
      user-follow-modify
      user-read-playback-state
      user-modify-playback-state
      user-read-currently-playing
      user-read-recently-played
    )
  |> Enum.join(",")

config :spotify_ex,
  user_id: System.get_env("SPOTIFY_USER_ID"),
  callback_url: System.get_env("SPOTIFY_CALLBACK_URL") || "http://localhost:4000/authenticate",
  client_id: System.get_env("SPOTIFY_CLIENT_ID"),
  secret_key: System.get_env("SPOTIFY_CLIENT_SECRET"),
  scopes: [spotify_scopes]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
