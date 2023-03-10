# Music Fixtures

I wanted to document this separately (and point to it from the documentation section) in the event this is useful or problematic in the future.
Fortunately, our codebase only has to read ID3 tags and it turns out we can copy those same tags into empty files!
While this looks like copyright infringement, it really shouldn't be because we're only working with the metadata of the files themselves, not the copyrighted content.

## Steps to Copy to an Empty File

1. Create an ` - Empty.mp3` version of the file you wish to write to. In our example case it is `1-14 Masamune - Empty.mp3`.
2. Run the command to copy the ID3v1 tag: `kid3-cli . -c "select '1-14 Masamune.mp3'" -c "tag 1" -c "copy" -c "select '1-14 Masamune - Empty.mp3'" -c "tag 1" -c "paste"`
3. Run the command to copy the ID3v2 tag: `kid3-cli . -c "select '1-14 Masamune.mp3'" -c "tag 2" -c "copy" -c "select '1-14 Masamune - Empty.mp3'" -c "tag 2" -c "paste"`
4. Repeat as necessary until your library is complete. Alternatively, this could likely be automated by iterating over directories.
5. Delete the original(s).
