# Beta Cohort Retrospective

Today is Friday, January 27, 2003 a full week after the demo day. I met with Brooklin on Wednesday as part of an exit interview to discuss mentorship availability and to get general feedback on the beta cohort.

Rather than focus on just demo day, which may not have a ton of material to cover, I thought it would be useful to cover the cohort as a whole.
The Capstone is the final focal point though and really encapsulates all of the material into a cohesive unit.

My first day joining the cohort was October 27. The first day according to recordings is September 21.

### Table of Contents

* [Agenda](#agenda)
* [What Went Well](#what-went-well)
* [What Could be Improved](#what-could-be-improved)
* [What Went Badly](#what-went-badly)
* [Focus for the Next Period](#focus-for-the-next-period)
* [Closing Thoughts](#closing-thoughts)

## Agenda

1. What went well (you’ll want to keep doing these things)
2. What could be improved (went OK, but could be better)
3. What went badly (you want to stop doing these things, if possible, or concentrate on doing them better)
4. A focus for the next period/sprint/month/quarter (One or two things to focus on)

## What Went Well

Capstone

1. Everyone loved the animated signal logo.
2. Using my blog colors and choices I made in 2019 saved a shitload of time.
3. The very basic MVP is there in terms of all the primary moving parts.
4. It looks pretty impressive because I stole behavior from iTunes and found a good existing Tailwind component for the sidebar. This was before getting access to Tailwind UI.
5. I was able to very rapidly prototype the core functionality using Livebook in the course of a few days. The days were spread out over time though, which helped my subconscious solidify concepts.
6. I had a lot of good habit days. Creating the journal manually in my Obsidian career vault was the key to my success.
7. I think I did well despite not personally covering a lot of what I missed. Exercism and prior knowledge filled in every gap poorly due to my failure to retain more information.

Cohort

1. Comraderies is the biggest takeaway. You can't help but become friends with the people that help you.
2. This is a dense community within another community.
3. A lot of material is covered, it's a really dense course that isn't overwhelming for someone with web framework experience.
4. The curriculum is paced for any experience level, the cohorts included. I needed less hand holding but I could also mentor and coach others.
5. Unlike Exercism, being accountable to a class kept me honest and focused.
6. I still had room to fuck off though, which goes both well and bad. I'll get to that later.

## What Could be Improved

Capstone

1. My code needs a bit of work for this project. Naming at the time of the demo is a little haphazard but I think I know how to group most things in contexts now.
2. A lot of my choices would revolve around my next project because I don't know how much I'll invest into this as-is. I think it's a great feature set but it "feels" like it's a part of something different. Either I need to make a streaming iTunes clone or some idea that turns it into a SaaS. This will be a great jumping off point for something else(TM).
3. Needed way more automated testing. I basically went on a 10 day spike spree and now I'm going to solidify tests and refactor as quickly as possible.
4. I do somewhat like having a "kitchen sink" where I throw in everything and keep what sticks. Will this ever use the full CI suite of functionality? Absolutely not. Will my next batch? Abso-damn-lutely. This is the perfect project to turn off 100% of the things I don't like.

Cohort

1. I'd say all my code overall may not be very idiomatic. I pilfer ideas from other people but I don't fully comprehend 90% of the trade offs (it gets close on some days). My intuition is usually right but I really need to define what that is and where it comes from.
2. Cover **all of the material**, even the parts I think I knew. There were techniques I hadn't really focused on before that I should have a handle on.

## What Went Badly

Capstone

1. This was 100% how I do **NOT** approach personal projects. I had 30+ days since I solidified my idea and even longer since I knew a capstone was a possibility. This idea had been on my plate a while so I honestly had no excuse to start and end sloppy.
2. I broke tests early and never used them again for the capstone. They would've helped some, I really needed to see results to rework some ideas.
3. I would always push to main. I wrote up issues but I didn't follow the typical Issue -> PR -> Merge pipeline I'm used to.
4. I followed a much more rigid structure with my blog with merging to main as an escape hatch.
5. I changed the data layer around quite a bit. I'm likely to do it again and "lock it in" during public release. Normally I'm a stickler for getting database columns just right and I do admit that I'm not a fan that Postgres can't order new table columns, they're always stacked at the end.
6. I spent a day generating AI artwork that actually came out pretty decent but I don't know if I'll ever use it for even the landing page. I do think it inspired ideas for the logo though.

Cohort

1. My good habit days were very very plentiful from November to December. Once the DockYard retreat happened and we had a week off, I completely lost my momentum.
2. I tried working out a dashboard using git commits that wasn't too difficult but the latter parts of the course were all mix projects, which weren't easily trackable. The manual Obsidian journal was useful but not insignificant amount of work every day or week when I'd sync things up.
3. I should've spent more time with repetitious learning. I absolutely need to go through the material again but with flash cards or other approaches. It may be worth extracting the drills and creating more that cover the basic Elixir and OTP.

## Focus for the Next Period

Capstone to Public Release

1. I've created a public branch that'll serve as a pre v0.2.0 of sorts. I need the ability to have my site deployed to Fly.io as it is now to compare with my final results.
2. I tagged `capstone` as the release closest to demo day.
3. Created a public alpha milestone that should cover the issues up to public release. This really centers around fixing tests and making the code base seem presentable.

Cohort

1. I need to schedule some time to go through the material again, to especially cover the parts I overlooked. This needs to happen within days not weeks.
2. Extract drills and built that into a web-based game library. There may be a way to leverage Livebook because typing with Intellisense can make a huge difference. It'd be nice to type with and without the hints.
3. Job search/Alumni meetings should happen at some point in the future. My guess is after the new cohort starts this may start to form. My only concern is going from a few hours to 6+ hours may leave a lot less time to flesh these things out.

## Closing Thoughts
