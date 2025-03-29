defmodule PhoenixTurboDemoWeb.MessageTURBO_STREAM do
  use PhoenixTurboDemoWeb, :html
  import PhoenixTurboDemoWeb.MessageHTML, only: [message_form: 1]

  embed_templates "message_turbo_stream/*"
end
