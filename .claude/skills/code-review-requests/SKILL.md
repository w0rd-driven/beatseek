---
name: code-review-requests
description: Request effective code reviews — specify focus areas, provide context, ask for Elixir/Phoenix architectural feedback.
---

# Code Review Requests

Focused review requests get actionable feedback. Vague requests get generic advice.

## Specify Focus Areas

### Vague

"Review this code"

### Focused

"Review `Beatseek.Verification.Spotify` for correctness and resilience:

**Focus on:**

- Does the `with` chain propagate `{:error, _}` correctly from Spotify API calls?
- Are Spotify rate limit responses handled gracefully?
- Could `add_missing_albums/1` create a race condition if called concurrently?
- Is `broadcast!/3` called after the DB write confirms, not before?
- Should `authenticate/1` be extracted to avoid re-authenticating on every call?

**Code:**

```elixir
def verify(id) do
  get_artist(id)
  |> get_albums()
  |> add_missing_albums()
end
```"

**Why it works:** Clear focus areas guide the review toward specific concerns.

---

## Provide Context

### Insufficient

"Is this context okay?"

### Sufficient

"Review `Beatseek.Scanner` for correctness:

**Context:**
- Scans a local directory of MP3 files, one file per album directory
- Runs in the browser via a LiveView button click — not a background job
- Known issue: scan upsert is too eager and overwrites verified data (#57)
- Collection size: ~5,000 albums typical, potentially 50,000+

**Concerns:**
- Is `Enum.uniq_by/2` applied in the right order to avoid missed deduplication?
- Should this run in an Oban job instead of synchronously to avoid blocking the LiveView?
- Is `MP3Stat.parse/2` safe to call in parallel with `Task.async_stream/3`?

**Code:** [paste `lib/beatseek/scanner.ex`]"

---

## Architectural Feedback

### Unclear

"Is the architecture good?"

### Clear

"Review the architecture of the verification pipeline:

**Current design:**

```
ArtistLive.Show (LiveView)
→ handle_event("verify", ...)
→ Workers.VerificationWorker (Oban)
→ Verification.Spotify.verify/1
→ Transformers.SpotifyArtistTransformer
→ Transformers.SpotifyAlbumTransformer
→ Artists.update_artist/2
→ Albums.create_album/1
→ Notifications.Delivery.deliver/1
```

**Concerns:**

1. `Verification.Spotify` calls `BeatseekWeb.Endpoint.broadcast!/3` — should broadcast be in the worker instead, after the transaction?
2. The Oban worker calls `Spotify.verify/1` which re-authenticates on every call — should credentials be cached?
3. Backfill chains jobs sequentially (1-second delay) — is this the right pattern for 5,000 artists?

**Questions:**

- Should the Spotify client be injected via a behaviour for testability?
- Where should the `verified_at` timestamp be set — in the worker or in `Verification.Spotify`?
- How should partial failures (one album fails, others succeed) be handled?"

---

## Elixir/Phoenix-Specific Review

### Generic

"Check if this follows best practices"

### Elixir-Specific

"Review for Elixir/Phoenix conventions:

**Code:**

```elixir
def handle_event("scan", _params, socket) do
  Beatseek.Scanner.scan()
  {:noreply, socket}
end
```

**Check for:**

- Should `Scanner.scan/0` run in an Oban job instead of synchronously?
- Is blocking the LiveView process safe for a long-running scan?
- Should this assign a `scanning: true` flag so the UI can disable the button?
- Is the return value of `Scanner.scan/0` being ignored intentionally?"

---

## Review Request Templates

### Template: Security Review

```
**Focus:** Security and data protection
**Code:** [paste code]
**Context:** [what user data is involved, auth requirements]
**Check for:**
- [ ] Input validated through Ecto changesets
- [ ] No `raw/1` on user data in HEEx templates
- [ ] Route in the correct auth pipeline
- [ ] No Spotify credentials in source or logs
```

### Template: Performance Review

```
**Focus:** Performance and scalability
**Code:** [paste code]
**Context:** [typical collection size, query frequency]
**Check for:**
- [ ] N+1 queries in Enum.map over DB results
- [ ] Missing indexes for new query patterns
- [ ] Large collections loaded into memory
- [ ] Oban job payload size
```

### Template: Architecture Review

```
**Focus:** Module boundaries and design
**Code:** [paste code or file list]
**Current design:** [describe the call chain]
**Check for:**
- [ ] Business logic in context, not in LiveView
- [ ] Transformers only do data shape conversion
- [ ] Workers only orchestrate; contexts own the logic
- [ ] PubSub broadcasts after DB commits
```

## Quick Reference

Effective review requests:

- **Specify focus** — security, performance, architecture, Elixir idioms
- **Provide context** — collection size, usage pattern, known constraints
- **Ask specific questions** — "should this be in an Oban job?" not "is this good?"
- **Reference known issues** — e.g., the scan upsert bug (#57) is context for any Scanner review
- **Show the call chain** — Elixir pipelines are easier to review with the full flow visible

## Related Skills

- `review-pull-request` — Automated multi-perspective PR review
- `apply-code-standards` — Code standards to reference in a review request
