# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What Beatseek Does

Beatseek scans a local MP3 music collection (reading ID3 tags via `Beatseek.MP3Stat`), stores artists/albums in a database, then verifies the collection against the Spotify API to discover missing albums. Missing albums trigger notifications.

## Commands

```bash
# Setup
mix setup                        # deps.get + ecto.setup + assets.setup

# Development
mix phx.server                   # start server at localhost:4000
iex -S mix phx.server            # start with IEx

# Database
mix ecto.setup                   # create + migrate + seed
mix ecto.reset                   # drop + ecto.setup

# Testing
mix test                         # run all tests (creates/migrates DB automatically)
mix test test/path/to/file_test.exs         # run a single test file
mix test test/path/to/file_test.exs:42      # run a single test by line number

# Quality checks (mirrors CI)
mix check                        # clean + compile + format + test + credo
mix format --check-formatted     # formatting check only
mix credo suggest --min-priority=normal
mix sobelow                      # security vulnerability check
mix xref graph --label compile-connected --fail-above 0  # compile-time dependency check
mix dialyzer                     # static analysis
```

## Required Environment Variables

Copy `.env.example` to `.env`. Required variables:

- `SCAN_DIRECTORY` — absolute path to MP3 collection root
- `SPOTIFY_CLIENT_ID` / `SPOTIFY_CLIENT_SECRET` — Spotify app credentials (for verification)
- `SPOTIFY_USER_ID` — Spotify user ID
- `SPOTIFY_CALLBACK_URL` — OAuth callback (e.g., `http://localhost:4000/authenticate` for dev)

## Architecture

### Core Data Flow

1. **Scan** (`Beatseek.Scanner`) — walks `SCAN_DIRECTORY/**/*.mp3`, parses ID3 tags via `Beatseek.MP3Stat`, upserts artists and albums via `Beatseek.Artists` and `Beatseek.Albums` contexts.
2. **Verify** (`Beatseek.Verification.Spotify`) — for each artist, queries Spotify Search API to find albums, then calls `add_missing_albums/1` which creates any not in the local DB and dispatches a notification via `Beatseek.Notifications.Delivery`.
3. **Background jobs** (`Beatseek.Workers.VerificationWorker`) — Oban worker that runs per-artist verification. Supports a `backfill: true` mode that chains through all unverified artists sequentially (1-second delay between each).

### Contexts

| Context | Module | Description |
|---|---|---|
| Artists | `Beatseek.Artists` | CRUD + upsert for artists |
| Albums | `Beatseek.Albums` | CRUD + upsert + `get_artist_album_by_name/2` |
| Notifications | `Beatseek.Notifications` | Notification records; `Delivery` sends them |
| Accounts | `Beatseek.Accounts` | phx.gen.auth user management |

### Transformers (`lib/beatseek/transformers/`)

Convert between ID3 tag maps and Ecto-compatible params (`ArtistTransformer`, `AlbumTransformer`), and between Spotify API responses and params (`SpotifyArtistTransformer`, `SpotifyAlbumTransformer`).

### Web Layer

- Phoenix LiveView for all main pages (artists, albums, notifications)
- `SidebarLive` — persistent sidebar component
- `PageController` — root `/` route renders the music dashboard
- Standard phx.gen.auth routes for user registration/login

### Background Jobs (Oban)

Oban is configured in `config/config.exs`. The `VerificationWorker` is the only worker. Jobs are inserted from LiveView actions (verify single artist or backfill all unverified artists).

## Known Issue

The scan upsert overwrites album data on every scan (issue #57). Scans and verify steps work correctly in isolation but not in sequence — a scan after verify will overwrite verified data.

## CI / Quality Gates

Four GitHub Actions workflows run on PRs:
- **Build and Test** — `mix compile --warnings-as-errors`
- **Quality Checks** — format, credo, unused deps, xref compile-connected, sobelow
- **Dialyzer** — static type analysis
- **Nightly Integration Test** — runs against production-like environment

`mix check` runs the same gates locally.
