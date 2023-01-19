# Wednesday, January 18

I spent a **ton of time overnight** brainstorming Oban usage and commenting on https://github.com/w0rd-driven/beatseek/issues/8. It's honestly a bit maddening how much time I spent not getting very far.
I think rather than staying in my head I should just push through until I find actual problems and not theoretical bugs.
I spent most of the day on styling notifications and getting the badge working when I soft-delete a notification by setting the `seen_at` date.
This also means a periodic Oban worker needs to prune old notifications after 30 days or some interval, eventually. If I make the page usable it may not be much of a concern for a while.

I think I spent a lot of time today on figuring out functional components, stateful components, and their shortcomings when it comes to events.
PubSub is pointless with a LiveComponent I believe, though I may be wrong, as there is no `handle_info` event to capture generic events. I'm using `send_update` to pass events down from the LiveView to the child LiveComponent.
It also sort of makes sense that while we have `live_session` and `on_mount` hooks that we don't want to have event or info hooks. The sidebar technically loads on each LiveView route under that process so each view would need to mount and have a handler to intercept the message.
This means all of the badges are subject to this limitation but if the sidebar was its own liveview with its own process, it could intercept the messages for all 3 components.
Each component also doesn't technically need state. This makes sense for a modal or what I should do with the notification page. Each notification block could be a live component as we want to trigger the delete event and propagate that up to the parent.
Even if things are half assed and I don't finish, I'm starting to get a very clear picture of the boundaries and where things start to make sense.

I'm also glad to some degree that I let go of tests. They're helpful for a lot of people but I need the feedback loop I have. This whole project should really be a spike.
Once I understand how to test these moving pieces, version 2 or 3 would start from solid footing. I'm at a point where I could be stuck by testing roadblocks very easily.

Maybe that makes me a more mediocre dev but frankly I don't give a fuck what anyone else thinks. It's taken me a long time to really hone in on how I create and I somehow make this shit work. If I can make a small v1 project generate multiples of my salary for almost 3 years using these methods, I must be doing something right.
That is also a project that has only seen attrition. New signups don't have subscription capabilities yet in my `$dayJob`'s Shopify store.
I don't like to brag like this but I could use the pep talk every so often for something I created in July 2020.
