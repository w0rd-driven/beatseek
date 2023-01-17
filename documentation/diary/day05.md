# Monday, January 16

What I believe to be left:

1. Add `Notifications` schema.
    1. `icon`, `subject`, `body`, `url`, `type`, `read_at`.
    2. subject: `#{API.name} was released on #{API.release_date}`.
    3. body: `API.payload`. We do need to store this somewhere.
    4. Types
        1. not_owned (better word?)
        2. new_release - Released within the last 6 months.
        3. upcoming - If APIs return future dates.
2. Customize `Notifications` page.
    1. Filter by type via dropdown, use Ecto.Enum documentation to build the list of types.
3. Wire up notification component via PubSub.
    1. I want to increment the counter via publish on each API call vs checking the database each time.
4. Implement the Spotify API logic.
    1. This is a **big fucking piece and kind of why this whole thing was made. Why am I leaving it until damn near last?**.
5. Add `badge count` component to Artist.
6. Add `badge count` component to Albums.
    1. Owned only or Owned / Total
7. Artist -> show
    1. This whole screen is incomplete as I should be showing a header and **all the child albums** with a sticky header.
    2. Create this as a master->detail screen.
8. Add `is_owned` badge of a green checkmark or a red x when not owned to all album displays.
9. Mobile sidebar shown or hidden using Tailwind breakpoints. See https://github.com/dbernheisel/bernheisel.com/blob/main/lib/bern_web/templates/layout/nav.html.heex. There's another example with Livebeats that does something similar.
10. Next
    1. Add `Settings` schema
        1. This should've been next but we do need to keep and track when the scan was last run and the API check was last run per artist (for 1 offs) or per attempt.
        2. `scanned_at`
        3. `checked_at`
    2. Customize `Settings` page.
    3. Profile looks out of place from the existing `phx.gen.auth` screens. I messed up the flexbox styling so it needs to be adjusted.
    4. Logout oddly doesn't send a DELETE request even though I'm using exactly what I think I should be.
    5. Login screen shows the sidebar.
        1. It's possible I need to do something like `if :active_tab == :nil, hide()`.
    6. Light and dark theme via https://github.com/dbernheisel/bernheisel.com/blob/main/assets/js/theme.js.

I "multitasked" again a little bit during class. I joined late at about 1:45 pm give or take and finally showed my face. I wanted to do more of that but kept forgetting.
I wanted to track what I have left to do here but a better version of myself would have this on GitHub in at least a private repo so I could work against issues.
This isn't my best work in terms of "how I should do it" but this v1 is likely going to be throwaway code.
I know I'm not doing TDD but I will shoot for having good test coverage because I think it's necessary to automate a lot of what I've been doing manually.
Right now I am in a bit of the artist mindset though, just pushing colors around on a canvas until things look good enough.

Part of me is a little disappointed in being harsh at first but I think a lot of that was the looming deadline and feeling like I was only walking uphill bothways during a blizzard. Now that something is functional and polish is somewhat there, a lot of the shock has worn off.
There are proposals to unify `phx.gen.auth` in the milestone section of GitHub. They know it's not up to par and the community is rallying to make it better. That's really what matters.
I also realize a lot of my friction comes from having a good experience with Laravel. There are generators or switches for just about every type imaginable.
I see at least one example of someone from the Laravel world adding generators and I suspect I'll be taking that and pushing it forward.
My frustration was largely centered around myself and the choice to wait until the last minute. I have excuses that aren't benign but I could've researched before typing.
It was also something I wasn't even planning on using out of the gate. I knew I didn't want to spend time on auth because my data model
isn't geared towards it.
I can't easily pair up the scanner to unique individuals so it's best to keep the basic application behavior as the star. Being able to customize the screens and know how to make them fit in an existing application does have merit.
I need to always be learning, even if I'm frustrated with myself for what little time I allow. It's also a lesson in priority and being able to push features, since that happens normally.
