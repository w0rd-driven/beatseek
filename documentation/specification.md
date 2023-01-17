# Specifications

Now, Next, Later

1. Globbing scan for all *.mp3s.
   1. Now: Restrict the scan to a single directory like iTunes?
   2. Later: Other audio formats could be useful.
   3. Store the base path minus the file name?
2. Read ID3v2 or possibly ID3v1 tags for metadata.
3. Filter unique metadata for Artist and Album.
   1. Later: Merge records.
4. Store metadata in database tables.
5. Background worker checks Spotify or another music API for missing albums.
6. Create a UI to display artist information.
   1. Absolutely steal from prior art like Apple Music, Amazon Music, Spotify, etc. This should be familiar
7. Send notifications.
   1. Now: In-app notifications as APIs are slowly polled throughout the month.
   2. Later: Email notifications?
   3. Next: Notification screen to view missing albums by artist.
8. View artist by missing albums.
   1. Next: Different views like owned, not owned, or possibly wish list?
   2. Now: Mixed views that show what's owned vs missing? One single view is likely preferred with filtering added later.
9. Later: Verify albums have all songs. Partial albums may count as incomplete.
   1. This likely changes the whole data format, we may store the full metadata including file name and full path.
   2. I may be entirely wrong about needing the path at any point. My mind says I need it but a scan of the entire iTunes 40gb is stupid fucking quick for what I expect. 5 seconds to read to the end of 40gb of files is impressive.
10. Later: Merge capabilities
11. This is likely where paths come in to resolve conflicts.

## Concepts

### User

User logging into the system.

Technically the root-level object though we'll likely fudge it as an MVP. I would need the ID3 crawler to be user aware when it currently runs on localhost.
The gen.auth scaffolding will take care of this.

### Artist

Music artist, i.e. `The Artist Formerly Known as Prince`.

Parent object created from ID3 crawler of at least a `name` to search Spotify. We are looking for new albums by artist.

### Album

Music artist's album(s) i.e. `Periphery III: Select Difficulty`.

Albums are either owned as found by the ID3 crawler or not as found on Spotify. Consists of the album `name`, `year`, `genre` and `is_owned`.

### Setting

This is where stuff starts to fall down because there are settings for scanning (local) and checking the API which can live anywhere. The v3 scanner would need to be configured independently and execute independently in this scenario.
If I make this a standalone application that solves most of this. I can still put up a demo on Fly.io, scanning would just not be functional as the local directories wouldn't exist there.

### Notification

Collection of notifications

Potential notification types

1. Album not owned and checked initially.
2. New releases. These are within x date, 6 months to a year? What defines a new release?
   1. Over the course of using the application, these should pop up ahead of time like on iTunes.
   2. This whole application was designed around replicating how iTunes alerts on new albums for a single artist. We want a UI that can handle and showcase several.
3. Email, Slack, Discord, and possibly other destinations? - Next or Later.

### Action - Next

Notification requiring action

Potential action types

1. On startup: ID3 tag ran x days ago, do you wish to run it now?
2. ID3 crawler has x albums but Spotify reports zero found. Did Spotify choose the right artist at index 0? I'm seeing artists like Persephone or Underoath when searching for Periphery. There looks to be a fuzzy search happening which we likely don't want.
3. Other corrective notifications like album names being close by `String.jaro_distance`.
4. ID3 is notoriously problematic as people ripping their own collection can easily supply the wrong metadata.

## Data Layer

1. User - `mix.gen.auth`
2. Artist
   1. `name:string`
   2. `path:string`
      1. Calculated by ID3 tag parent parent directory, if the names match within a threshold.
   3. `image_url:string`
      1. Spotify
   4. `checked_at:utc_datetime_usec`
   5. `mix phx.gen.live Artists Artist artists name:string path:string image_url:string checked_at:utc_datetime_usec`
3. Album
   1. `name:string`
   2. `genre:string`
      1. Periphery is `Progressive Metal / Math Metal / Djent` in ID3. Spotify lists this on the artist as `"djent", "melodic metalcore", "progressive metal", "progressive metalcore"`.
   3. `year:string`
      1. ID3 as string.
      2. Spotify as `release_date` and `release_date_precision` which may be day/datetime oriented.
   4. `is_owned:boolean`
      1. I like knowing field types by naming convention. The `is_` boolean convention is something I picked up long ago.
   5. `path:string`
      1. Path to the ID3 tag's base directory.
   6. `image_url:string`
      1. Extracted from ID3 or Spotify.
   7. `mix phx.gen.live Albums Album albums name:string genre:string year:string release_date:date is_owned:boolean path:string image_url:string artist_id:references:artists`
4. Settings
   1. `scanned_at:utc_datetime_usec`
   2. `checked_at:utc_datetime_usec`
   3. Next
      1. `directories`: embedded JSON?
5. Notifications
   1. `album_id:integer`
   2. `icon:string`
   3. `subject:string`
   4. `body:text`
   5. `url:text`
   6. `type:enum` - See https://hexdocs.pm/ecto/Ecto.Enum.html
   7. `seen_at:utc_datetime_usec`
   8. `mix phx.gen.live Notifications Notification notifications icon:string subject:string body:text url:text type:string seen_at:utc_datetime_usec album_id:references:albums`
6. Actions - Next
   1. `table_name:string`
   2. `table_id:integer`
   3. `title:string`
   4. `payload:text`
   5. `type:enum` - See https://hexdocs.pm/ecto/Ecto.Enum.html
   6. `completed_at:utc_datetime_usec`

## User Interface

### Sidebar Navigation

I see in my mind an application that takes the same sidebar as Livebeats as the left panel that looks something like [https://tailwindcomponents.com/component/navigation-component].

1. Dashboard? - Next/Later
2. Search? - Next
3. Music
   1. Artists with badge count(s)
   2. Albums with badge count(s)
4. Account
   1. Profile
   2. Settings
   3. Notifications with badge
   4. Actions?

### Status bar - Next

1. Sticky footer
2. Message panel
   1. Click to open log
3. Icon panel
   1. Icon coloring showing application state. Should link to actions?

### Albums

1. Vertical scrolling list
   1. Filter?
   2. Sort by Name or Date?
   3. Image, uses default if no `image_url` found
   4. Name
2. Albums side panel
   1. Name
   2. X Albums
   3. Dot Menu
      1. Check for new albums
   4. Image, uses default if no `image_url` found
   5. Name
   6. 1st Genre * Year
   7. Missing albums opacity

### Artists

1. Grid of images, uses default if no `image_url` found
   1. Name | Year
   2. Artist Name
   3. Missing albums opacity
   4. Filter by found, not found
   5. Wishlist - Next

### Settings

1. Directories
   1. Table of directory names
   2. CRUD buttons
2. Schedules
   1. Scan
   2. API Check
3. Scan
   1. Scan on startup
4. Check
   1. Check automatically on new artist
   2. Retry x times
   3. Exponential backoff - Next

## Implementation Brainstorm

The UI will need to be able to perform any steps manually, namely the scan and check.

Scanning should be a named supervised GenServer.

1. start message
   1. Run on startup?
   2. Set `is_scanning` conditional to lock and prevent multiple full scans.
   3. Run full scan algorithm.
2. scan path message
   1. Handled any portion of the path, could be a recursive function to walk the directory tree if necessary.
   2. Handles each path configured in the settings.
3. scan - Scan module
   1. Build an enumerable of ID3 tags.
   2. For each tag, create album then create each artist.
   3. When artist is complete, send check artist name event.

Check should also be a named GenServer.

1. start message
   1. Run on startup?
   2. Set `is_checking` conditional to lock and prevent multiple full system checks.
   3. Run full check algorithm.
2. check artist name message
   1. For each album returned, String.jaro_distance to try to match each name in the database.
   2. Add missing album with `is_owned = false`.
   3. Send notification, if within a year it should be a new release otherwise a found.
3. check - Check module
   1. Does Spotify library handle retries? Exponential backoff? Caching? Req does so much and it could potentially be trivial to handle OAuth.
