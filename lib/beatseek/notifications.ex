defmodule Beatseek.Notifications do
  @moduledoc """
  The Notifications context.
  """

  import Ecto.Query, warn: false
  alias Beatseek.Repo

  alias Beatseek.Notifications.Notification

  @doc """
  Returns the list of notifications.

  ## Examples

      iex> list_notifications()
      [%Notification{}, ...]

  """
  def list_notifications do
    Repo.all(Notification)
  end

  @doc """
  Gets a single notification.

  Raises `Ecto.NoResultsError` if the Notification does not exist.

  ## Examples

      iex> get_notification!(123)
      %Notification{}

      iex> get_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification!(id), do: Repo.get!(Notification, id)

  @doc """
  Creates a notification.

  ## Examples

      iex> create_notification(%{field: value})
      {:ok, %Notification{}}

      iex> create_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification(attrs \\ %{}) do
    %Notification{}
    |> Notification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notification.

  ## Examples

      iex> update_notification(notification, %{field: new_value})
      {:ok, %Notification{}}

      iex> update_notification(notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification(%Notification{} = notification, attrs) do
    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a notification.

  ## Examples

      iex> delete_notification(notification)
      {:ok, %Notification{}}

      iex> delete_notification(notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification(%Notification{} = notification) do
    Repo.delete(notification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification changes.

  ## Examples

      iex> change_notification(notification)
      %Ecto.Changeset{data: %Notification{}}

  """
  def change_notification(%Notification{} = notification, attrs \\ %{}) do
    Notification.changeset(notification, attrs)
  end

  @doc """
  Returns the list of notifications not seen yet.

  ## Examples

      iex> list_unseen_notifications()
      [%Notification{}, ...]

  """
  def list_unseen_notifications do
    Notification
    |> where([notification], is_nil(notification.seen_at))
    |> Repo.all()
  end

  @doc """
  Returns a count of notifications not seen yet.

  ## Examples

      iex> get_unseen_notification_count()
      0

  """
  def get_unseen_notification_count do
    Notification
    |> where([notification], is_nil(notification.seen_at))
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Marks a notification as seen.

  ## Examples

      iex> update_notification(notification)
      {:ok, %Notification{}}

  """
  def mark_notification_as_seen(%Notification{} = notification) do
    attrs = %{seen_at: DateTime.now!("Etc/UTC")}

    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end
end
