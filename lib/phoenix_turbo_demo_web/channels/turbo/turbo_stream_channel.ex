defmodule PhoenixTurboDemoWeb.Turbo.TurboStreamChannel do
  use PhoenixTurboDemoWeb, :channel

  intercept ["refresh"]

  @impl true
  def join(topic = "turbo_stream:" <> _turbo_stream_topic, %{"signed_topic" => signed_topic}, socket) do
    case PhoenixTurboDemo.Token.verify(socket, signed_topic) do
      {:ok, ^topic} ->
        {:ok, socket}
      _ ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  def join("turbo_stream:" <> _turbo_stream_topic, _payload, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  @impl true
  def handle_out("refresh", %{request_id: request_id}, socket) do
    stream = Phoenix.Template.render_to_string(PhoenixTurboDemoWeb.Turbo.TurboStream, "refresh", "turbo_stream", request_id: request_id)
    push(socket, "message", %{data: stream})
    {:noreply, socket}
  end
end
