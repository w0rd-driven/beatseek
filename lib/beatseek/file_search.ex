defmodule Beatseek.FileSearch do

  def search() do
    # file_name = "/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Juggernaut_ Alpha/1-01 A Black Minute.mp3"

    # Beatseek.MP3Stat.parse(file_name)

    directory = "/Users/jbrayton/Music/iTunes/iTunes Media/Music"
    files = "/**/**/*.mp3"

    path = Path.join(directory, files)

    Path.wildcard(path)
    |> Enum.map(fn path ->
      # Read tags
      case Beatseek.MP3Stat.parse(path) do
        {:ok, tag} -> tag
        {:error, _error} -> %{}
      end
    end)
    |> Enum.uniq_by(fn tag ->
      # Filter down to unique artist/album pairs
      # It would be quicker to use a MapSet to stay unique
      # ETS could work but overkill, why not benchmark it?
      if tag != %{} do
        tag.artist && tag.album
      end
    end)
    |> Enum.sort_by(
      fn tag ->
        tag.artist
      end,
      :asc
    )

    # LiveBeats takes about 70+ seconds for everything on my machine
    #   this is doing the extra work of determining the duration, which we don't need.
    #   I could perform the surgery needed to strip that out.
    # There are already issues with this though, like the year possibly being TYER or TDRC
    # It's much easier to just use the Rust implementation, especially considering we may make that
    #   our "collector".
    # Elixir-native parsing isn't a terrible idea eventually, I just don't have the time as a capstone.
  end

  def better_search() do
    directory = "/Users/jbrayton/Music/iTunes/iTunes Media/Music"
    files = "/**/*.mp3"

    path = Path.join(directory, files)

    Path.wildcard(path)
    |> Enum.uniq_by(fn file_path ->
      # Now we filter by parent directory, from 4823 to 443
      file_path
      |> Path.dirname()
      # |> IO.inspect(label: "Basename")
    end)
    |> Enum.map(fn path ->
      # Read tags
      case Beatseek.MP3Stat.parse(path) do
        {:ok, tag} -> tag
        {:error, _error} -> %{}
      end
    end)
    |> Enum.uniq_by(fn tag ->
      # Filter down to unique artist/album pairs
      # It would be quicker to use a MapSet to stay unique
      # ETS could work but overkill, why not benchmark it?
      if tag != %{} do
        tag.artist && tag.album
      end
    end)
    |> Enum.sort_by(
      fn tag ->
        tag.artist
      end,
      :asc
    )
  end

  def even_better_search() do
    directory = "/Users/jbrayton/Music/iTunes/iTunes Media/Music"
    files = "/**/*.mp3"

    path = Path.join(directory, files)

    Path.wildcard(path)
    |> Enum.uniq_by(fn file_path ->
      # Now we filter by parent directory, from 4823 to 443
      file_path
      |> Path.dirname()
      # |> IO.inspect(label: "Basename")
    end)
    |> Enum.map(fn path ->
      # Read tags
      case Beatseek.MP3Stat.parse(path, no_duration: true) do
        {:ok, tag} -> tag
        {:error, _error} -> %{}
      end
    end)
    |> Enum.uniq_by(fn tag ->
      # Filter down to unique artist/album pairs
      # It would be quicker to use a MapSet to stay unique
      # ETS could work but overkill, why not benchmark it?
      if tag != %{} do
        tag.artist && tag.album
      end
    end)
    |> Enum.sort_by(
      fn tag ->
        tag.artist
      end,
      :asc
    )
  end

  def benchmark() do
    
  end
end
