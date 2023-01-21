# Thursday, January 19

I'm writing the start of this at 1:30 am while I try to quickly pull some documentation together and backlink all of these files together.

I can write up something for today but it's also hazy considering I didn't sleep until 5:30 am and I was up late the night before as well. Somehow my late night shower gave me a huge second wind.

Okay it's now Saturday early because I'm still on a weird sleep schedule and compelled to button this up. Looking back at my git history, this is one of the most productive days in terms of numbers of commits and complexity.

1. Album art was pushed to its own stateless component. Anything that repeats should be a stateless component in most cases. This means the grid, artist show screen, and notifications. There are likely more instances.
2. Diary cleanup and added a parent index for the documentation tree.
3. Changed heading text-xl and above to h2/h3 tags with h1 being reserved for the logo I believe? I don't think any of this passes Lighthouse with usable scores.
4. First deployment to Fly.io a success. Subsequent deploys were shit though but some of that was on me.
5. Refactored Sidebar to its own LiveView per @Brook's suggestion. It was easier than I thought.
6. Moved logo to the sidebar because a heading doesn't make a ton of sense. I'm fine with following Livebeat's lead here though the sidebar should be distinct with a clear separation according to Refactoring UI I believe.
7. Notification delivery stubbing and `ecto.dump` usage. I had weird issues after trying to use `ecto.load` though around foreign keys. I added a data migration manually to the end.
8. CI deploys to Fly.io.
9. Changed background color for the page from `bg-white` to my blog's color. This required a style adjustment for just about every page.
10. Got in-app notification delivery working \o/.
11. Installed SpotifyEx and configured Oban worker. Spotify was **rough** but a take-home assignment I completed around this time last year saved my ass. I had gotten individual calls working without the need for the whole OAuth flow. This was huge and I worked out how to debug issues in the Github issue.
    1. The spotify library is looking for **compile-time settings** and this requires it to **not be in runtime.exs**. It took me a minute to understand this. The fix required running each function in the main `spotify_ex` entrypoint and using `System.get_env` to make sure my `.env` file was set up completely.

Things really started to come together but I knew I ran out of time and steam at 5 am. I had just enough time to pull things off and give a decent presentation but I wish I had more time to make slides and screenshots.
I was winging it completely because I had worked literally up until it was my time to present. I really need to look at the recording to see what I missed and capture the file for personal use.
I like studying myself in these situations but I'd love to also have it up on YouTube or something if given permission to edit down to just my part.

I'm glad things are over but I'm still sad because I poured so much time into it. I clearly didn't give myself enough time for this but it was a lot to pull off in about 10 days. I really should've given myself the full 30+ but I think things were churning in my subconscious a while.
