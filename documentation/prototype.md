# Prototyping

I'm not quite sure if I'll have the time as I'm going in a million different directions it feels like.
My hope is to prototype all of the moving parts individually as spikes then throw them away with testing in mind.
I'm absolutely a fan of Livebook Driven Development but I do need to start working with databases sooner rather than later.

## Stages

1. [Reading ID3 tags](livebooks/discography_prototype_id3.livemd).
    1. I tried different approaches where I think Livebeats wins for the pure Elixir implementation for now.
    2. The rust version was really slick too once I got it working. For a "very slow implementation" according to the Author, it runs pretty damn quick for a 40gb collection.
    3. Rust makes sense because a v3 approach would be to have Rust binaries for every OS target. The local agents would send information back to a centralized API. This could potentially stream your collection but that's likely way out of scope.
    4. Livebeats calculates the duration and depends on it being > 0 to return results.
2. [Calling Music APIs](livebooks/discography_prototype_api.livemd).
    1. Tried the APIs `MusicBrainz`, `TheAudioDB`, `Discogs`, and `Spotify`.
    2. `MusicBrainz` is great for being free with no authentication required. I only just realized there could be auth for other fields like pictures but I doubt it.
    3. `Discogs` is a good alternative to Spotify that only requires a personal token vs the OAuth flow. OAuth is fine but I've seen it typically use a GenServer to take care of token capture.
    4. We're going with Spotify because it's pretty standard and I could see some integration opportunities.

I'm not sure what else I could be prototyping via Livebook at this point as it'll largely come down to quickly churning out a relevant UI.
I absolutely ran out of time to be ready for demo day on 1/20/23 as it's 9 days away and I'm only at this point.
I'm seriously contemplating no tests or only covering what gets generated. Livebeats covers MP3Stat so I could likely just steal that.
