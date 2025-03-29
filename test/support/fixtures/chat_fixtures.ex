defmodule PhoenixTurboDemo.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixTurboDemo.Chat` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> PhoenixTurboDemo.Chat.create_room()

    room
  end

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> PhoenixTurboDemo.Chat.create_message()

    message
  end
end
