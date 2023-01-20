import Config

# It's easier to build this full list from the console as they don't give a comma delimited list anywhere
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
