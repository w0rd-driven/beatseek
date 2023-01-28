# Sunday, January 15

It's technically early again as I had a family day and slept until almost 2 am. It's now 4 am and I'm importing the AI artwork generated and looking to Livebeats for heavy inspiration.
I know I want a sidebar with similar navigation made to look close to iTunes as possible to save time. I'm really under the gun here and I haven't even moved to the API part yet.
I do think that'll go pretty smoothly and if I work PubSub right, it'll all just work(tm) if I have the components in place.

I tried using `conn |> put_layout(:live) |> render(:music)` and that wouldn't work. I was looking to replicate LiveBeats by keeping the layout separate but I could not get that to work.
It's like it always looked for `:app` no matter what. At least I finally have a visible functional sidebar at almost 6 am.

It's now Monday at 3pm but I should be able to recap. I did work in the office after class and quite a bit during class "multitasking" or otherwise known as barely paying attention to class.
We're going over the last example, sending email newsletters with Oban. Oban is likely going to be the workhorse for my background processes and retrying.

So back to the day. I got the sidebar to be sticky in tailwind finally and at least the finished `albums` view looks slick as shit. I started moving on to notifications.
I did get to sleep around 3 am and watched The Last of Us so I didn't spend a ton of time on it after the office time.
As of right now the Artists, Albums, and janky looking Profile pages are functional.
