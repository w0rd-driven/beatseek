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
