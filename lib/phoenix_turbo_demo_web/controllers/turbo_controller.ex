defmodule PhoenixTurboDemoWeb.TurboController do
  import Plug.Conn, only: [get_req_header: 2, assign: 3]
  alias Phoenix.Controller

  def turbo_frame(conn, opts \\ []) do
    turbo_frame = get_turbo_frame(conn)
    conn = if opts[:assign_as], do: assign(conn, opts[:assign_as], turbo_frame), else: conn

    if turbo_frame, do: Controller.put_layout(conn, false), else: conn
  end

  def get_turbo_request_id(conn) do
    conn
    |> get_req_header("x-turbo-request-id")
    |> List.first()
  end

  defp get_turbo_frame(conn) do
    conn
    |> get_req_header("turbo-frame")
    |> List.first()
  end
end
