defmodule Pitanja.Web.RegistrationController do
  use Pitanja.Web, :controller
  alias Pitanja.Accounts
  alias Pitanja.Accounts.User

  action_fallback Pitanja.Web.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)
        conn
        |> put_status(:created)
        |> render(Pitanja.Web.SessionView, "login.json", jwt: jwt, user: user)
    end
  end
end
