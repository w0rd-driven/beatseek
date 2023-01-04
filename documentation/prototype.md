# Prototyping

I'm not quite sure if I'll have the time as I'm going in a million different directions it feels like.
My hope is to prototype all of the moving parts individually as spikes then throw them away with testing in mind.
I'm absolutely a fan of Livebook Driven Development but I do need to start working with databases sooner rather than later.

## Stages

1. [Reading ID3 tags](livebooks/discography_prototype.livemd)
    1. I tried different approaches where I think Livebeats wins for the pure Elixir implementation for now.
    2. The rust version was really slick too once I got it working. For a "very slow implementation" according to the Author, it runs pretty damn quick for a 40gb collection.
    3. Rust makes sense because a v3 approach would be to have Rust binaries for every OS target. The local agents would send information back to a centralized API. This could potentially stream your collection but that's likely way out of scope.
    4. Livebeats calculates the duration and depends on it being > 0 to return results.
