defmodule PhoenixTurboDemoWeb.MessageController do
  use PhoenixTurboDemoWeb, :controller
  plug :accepts, ["html", "turbo_stream"] when action in [:create]

  alias PhoenixTurboDemo.Chat
  alias PhoenixTurboDemo.Chat.Message

  def new(conn, %{"room_id" => room_id}) do
    changeset = Chat.change_message(%Message{}, %{"room_id" => room_id})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"room_id" => room_id, "message" => message_params}) do
    case Chat.create_message(Map.merge(message_params, %{"room_id" => room_id})) do
      {:ok, message} ->
        broadcast_room_turbo_stream_refresh(message.room_id)

        if get_format(conn) == "turbo_stream" do
          changeset = Chat.change_message(%Message{}, %{"room_id" => room_id})
          render(conn, :new, changeset: changeset)
        else
          conn
          |> put_flash(:info, "Message created successfully.")
          |> put_status(:see_other)
          |> redirect(to: ~p"/rooms/#{message.room_id}")
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:new, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Chat.get_message!(id)
    {:ok, _message} = Chat.delete_message(message)

    turbo_request_id = get_turbo_request_id(conn)
    broadcast_room_turbo_stream_refresh(message.room_id, turbo_request_id)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> put_status(:see_other)
    |> redirect(to: ~p"/rooms/#{message.room_id}")
  end

  defp broadcast_room_turbo_stream_refresh(room_id, request_id \\ nil) do
    # stream = Phoenix.Template.render_to_string(PhoenixTurboDemoWeb.Turbo.TurboStream, "refresh", "turbo_stream", request_id: request_id)
    # PhoenixTurboDemoWeb.Endpoint.broadcast("turbo_stream:room_#{room_id}", "message", %{data: stream})
    PhoenixTurboDemoWeb.Endpoint.broadcast("turbo_stream:room_#{room_id}", "refresh", %{request_id: request_id})
  end
end
