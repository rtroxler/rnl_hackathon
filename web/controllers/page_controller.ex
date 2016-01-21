defmodule RnlHackathon.PageController do
  use RnlHackathon.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
