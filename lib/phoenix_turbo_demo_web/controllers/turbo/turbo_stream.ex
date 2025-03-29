defmodule PhoenixTurboDemoWeb.Turbo.TurboStream do
  use PhoenixTurboDemoWeb, :html

  def refresh(assigns) do
    ~H"""
    <.turbo_stream action="refresh" request_id={@request_id} />
    """
  end
end
