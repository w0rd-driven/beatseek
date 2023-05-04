# Beatseek

Beatseek uncovers the gaps in your music collection by verifying your local files against the Spotify API.

### Table of Contents

* [Documentation](#documentation)
* [Phoenix Framework](#phoenix-framework)
    * [Learn more](#learn-more)

## Documentation

* [Specification](documentation/specification.md)
* [Prototyping Methodology](documentation/prototype.md)
    * [Reading ID3 tags](documentation/livebooks/discography_prototype_id3.livemd)
    * [Calling Music APIs](documentation/livebooks/discography_prototype_api.livemd)
* [Time Tracking](documentation/timetracking.md)
    * I ended up abandoning this very early but it was helpful in determining when I started.
* [Developer Journal](documentation/journal/index.md)
    * Day 1-x: Missing as I didn't track my preliminary prototype work very well at all.
    * [Day 2 :: Thursday, January 12](documentation/journal/day02.md)
    * [Day 3 :: Friday, January 13](documentation/journal/day03.md)
    * [Day 4 :: Sunday, January 15](documentation/journal/day04.md)
    * [Day 5 :: Monday, January 16](documentation/journal/day05.md)
    * [Day 6 :: Tuesday, January 17](documentation/journal/day06.md)
    * [Day 7 :: Wednesday, January 18](documentation/journal/day07.md)
    * [Day 8 :: Thursday, January 19](documentation/journal/day08.md)
    * [Day 9 :: Thursday, January 20](documentation/journal/day09.md)
    * [Capstone complete!!](documentation/journal/cohort-retrospective.md)
    * [Public release day](documentation/journal/release-retrospective.md)
* [AI Artwork](documentation/artwork/index.md)
    * I spent the better part of Saturday trying to generate artwork I may use on a landing page. These would look out of place as a 48x48 logo as they're a little too detailed.

**KNOWN ISSUES**:

* [ ] [The scan upsert is a little too eager](https://github.com/w0rd-driven/beatseek/issues/57)
    * Every scan acts like an insert or update, overwriting updates that happen during the verify stage.
    * Scans should be indempotent, the date placeholders changing makes this untrue.
    * I failed to test multiple workflows until the UI was wired up. Scans and verify steps work perfectly fine in isolation.

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
