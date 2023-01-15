# Thursday, January 12

Honestly, this is likely day 5 or 6 if I were honestly counting but I wanted to keep track of what I'm feeling as I go through this.
Right out of the gate I realized how absolutely spoiled I am in the Laravel ecosystem because I ran into 2 issues and noticed a third.
To be 100% clear, Laravel has its own problems that usually center around sometimes very poor documentation or hidden gems like the fact
that caching your config and your routes noticeably improves performance even on your local machine. The number of developers and projects
that just forget or omit this is staggering but it's not exactly called out in any capacity.

1. Running `mix phx.gen.presence --help` generates a presence file named `--help` which breaks compilation. I'll submit a PR.
2. `mix phx.gen.auth` feels so fucking out of place.
    1. The screens and components themselves are lovely but the way navigation is just slapped on the page is awkward af.
    2. Why use 1 migration instead of at least one per table, if not more? Laravel has points where it doubled up in the past but they stopped doing it. I get that a lot of migrations is a problem over time but I've always preferred to separate concerns, even there. I get that one could argue the concerns are together though.
    3. The work I'm going to have to do to make navigation presentable almost feels like I should rip it out. Laravel isn't free from completely gutting a page or component but the default out of the box experience is presentable for doofuses like me that don't want to screw with one more thing(TM).
    4. What was running through my head was this felt like a reverse of Elden Ring. With that game, FromSoft took nuggets from GRRM and created something spectacular. Tailwind providing the screens was like GRRM's influence but the navigation is **so unpolished in comparison**. I know I feel like an asshole for how I'm saying this. My plan is to not just complain though, I'm using this language to kick my own ass into changing it for the better, one way or another.
3. `lib/beatseek/accounts/user_notifier.ex` has text-only email bodies. I should really look into bringing this from Laravel because we write emails in Markdown that get converted to **both text and html**. One format, two outputs. Not only that but the HTML emails are branded to look like the site out of the gate.

It's technically Friday early now so I'll move my thoughts there after not doing much other than brainstorming all day. I wanted to let my mind really pour over what I wanted this to look and behave like.
