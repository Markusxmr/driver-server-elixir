defmodule Pitanja.Web.CurrentUserController do
  use Pitanja.Web, :controller

  #plug Guardian.Plug.EnsureAuthenticated, handler:Pitanja.SessionController

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    conn
    |> put_status(:ok)
    |> render("show.json", user: user)
  end
end
