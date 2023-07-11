# Beatseek

Beatseek uncovers the gaps in your music collection by verifying your local files against the Spotify API.

### Table of Contents

* [Documentation](#documentation)
* [Troubleshooting](#troubleshooting)
* [Phoenix Framework](#phoenix-framework)
    * [Learn more](#learn-more)

## Documentation

* [Specification](documentation/specification.md)
* [Prototyping Methodology](documentation/prototype.md)
    * [Reading ID3 tags](documentation/livebooks/discography_prototype_id3.livemd)
    * [Calling Music APIs](documentation/livebooks/discography_prototype_api.livemd)
* [Time Tracking](documentation/timetracking.md)
    * I ended up abandoning this very early but it was helpful in determining when I started.

**KNOWN ISSUES**:

* [ ] [The scan upsert is a little too eager](https://github.com/w0rd-driven/beatseek/issues/57)
    * Every scan acts like an insert or update, overwriting updates that happen during the verify stage.
    * Scans should be indempotent, the date placeholders changing makes this untrue.
    * I failed to test multiple workflows until the UI was wired up. Scans and verify steps work perfectly fine in isolation.

## Troubleshooting

* To connect to the database via TablePlus, run the command `fly proxy 15432:5432 -a beatseek-db` in a dedicated terminal to keep the proxy active.
    * See [https://community.fly.io/t/how-can-i-connect-my-production-fly-database-to-gui-e-g-tableplus/7069] for resources.
    * This technique was used to backup and restore local data to the production database. I'm very much at home using a database GUI over custom commands and the fact that mix is not installed in releases makes this more challenging than I'm used to. Laravel deploys the comperable `artisan`.
* "Only valid bearer authentication supported"
    * This is shown in the `oban_jobs` table or displayed when using the UI for an individual artist
    * The full error is:

    ```elixir
    ** (MatchError) no match of right hand side value: {:ok, %{"error" => %{"message" => "Only valid bearer authentication supported", "status" => 400}}}
        (beatseek 0.1.0) lib/beatseek/verification/spotify.ex:17: Beatseek.Verification.Spotify.get_artist/1
    ```

    * The secrets `SPOTIFY_USER_ID`, `SPOTIFY_CLIENT_ID`, and `SPOTIFY_CLIENT_SECRET` were not set or not migrated to v2.
    * To fix, use `fly secrets set <copied line from .env>` and repeated until all variables have been set.
    * Other secrets not in our local environment are `DATABASE_URL`, `RELEASE_COOKIE`, and `SECRET_KEY_BASE`.
* "Constraint error when attempting to insert struct: * albums_pkey (unique_constraint)"
    * The full error is:

    ```elixir
    ** (Ecto.ConstraintError) constraint error when attempting to insert struct:
    * albums_pkey (unique_constraint)
    If you would like to stop this constraint violation from raising an
    exception and instead add it as an error to your changeset, please
    call `unique_constraint/3` on your changeset with the constraint
    `:name` as an option.
    The changeset has not defined any constraint.
    ```

    * The migration created `create unique_index(:albums, [:artist_id, :name])` so it should be a unique artist_id AND name here.
    * The changeset doesn't include this and the docs specify to reverse the order as "name" would be the error key we want.
    * This oddly isn't a problem locally and I wonder if it's due to importing the table data directly
    * To view the current values in a sequence, use the SQL `SELECT last_value FROM albums_id_seq;` or `SELECT pg_sequence_last_value('public.albums_id_seq');` also works
        * See [https://stackoverflow.com/a/14886371/134335]
    * The fix is `SELECT setval('albums_id_seq', (SELECT MAX(id) FROM albums));` for each table affected, `artists` and `albums`.

## Phoenix Framework

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
