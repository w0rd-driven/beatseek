# Friday, January 20

The last day was very bittersweet for me and I think everyone else as well. There were some pretty touching moments. I don't know what I thought going in but I think everything went well for me and the rest of the team.
I do want to give more of a post mortem at some point and I'm trying to work to get this to "public ready." I desperately want time off but I fear I'll lose all my motivation if I do. I'm going to try to play God of War: Ragnarok tonight though. I've earned it.

SpotifyEx was a huge PITA but fortunately me from a fucking year ago was clutch. Turns out I used this in a take home assignment and actually got the OAuth handshake roughly working or really it was just getting the token needed.
There are examples for using an Agent and keeping the tokens rotated but fuck that for now.

I think I was up until 5:30 am last night, got up at 10:00 for our 10:10 standup at work, wrote a status report and went back into head's down mode.
I was still working as presenters were going.

Jon and Icia collaborated and created these bomb ass slides in what looked like a day. They were literally talking about it last night and pulled off some impressive demos.
Jon made a meditation app that plays MP3s and Icia has a behavioral psychology site that's really polished. Andrew didn't have much and almost didn't show it but it's a Elixir words per minute typing game.
He spent the full 10 minutes talking anyway because there were things to talk about even in a rough state. Bill showcased what he's worked on for Elixir Newbie v2 in pulling the DockYard Academy curriculum and trying to reduce the friction of needing GitHub right out of the gate.

- Jon: https://nsdr.fly.dev/
- Icia: https://psyinit.fly.dev/en
- Andrew: ?
- Me: https://beatseek.fly.dev
- Bill: ?
- Swammy: ?

I'd like to link all of the public repositories at some point.

I'll likely write more later or maybe tomorrow. I spent almost too much time fucking with Fly.io. When it works it's great. When it doesn't, I wanna yeet it into the sun.
I also just don't really know how to start debugging from a remote iex shell. I'm used to seeing the logs and I didn't bother googling.
I first tried connecting to TablePlus which took forever, then did a backup/restore. I restored over postgres because it didn't seem to work when tables exist.
I believe it's because Postgres has a form of locking that I couldn't figure out. I did use the `--create` command in TablePlus which created a `beatseek_dev` table :facepalm: then I got smart.
I used TablePlus' `Copy Rows As > INSERT Statement` and ran SQL to import. Things work as expected now.
I believe a portion of my Fly woes was .dockerignore adding .env because I added it later for Spotify. I remember Icia talking about it when she had issues and it seems to be running smoothly now when I reverted that change.

I'm trying to button things up now a little. I realized I missed the image_url from Spotify and I really want to get Oban functional. I'll then want to go through and create a `Public` milestone and a `Capstone` milestone or something.

I also have a few ideas for my next gig. My pitches idea would be perfect for demo days because we can create talks and have an understanding of how long a script would take to read. I need this for job interviews to give elevator pitches but there's a ton of versatility.
Andrew inspired me to either make my own WPM using Elixir modules and reading doctests or to get back into the Wordle prototype. I think both games could be part of an arcade of sorts.
Wordle alone has a ton of modes I'm thinking of like Elixir modules, just Mix tasks, Erlang, all the above. Typing full module names or just the last part. There's just so much to do with just that one.
Lastly is my Altar concept to write up the times God/Jehovah/Yahweh has saved my ass. It'd be in a GitHub activity timeline almost ripped off entirely. I'd be encouraged to write as many as possible but also randomly show a part of my timeline.
There's so much I've forgotten but just recently: We got a bonus at work which isn't much at all according to my coworkers that used to see double or triple but when my family **needs money like we do**,
that wasn't guaranteed. Taxes are also going to be a refund and I was absolutely shitting myself thinking we could owe. We have on numerous ocassions.
