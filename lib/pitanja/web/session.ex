defmodule Pitanja.Web.Session do
  @moduledoc """
  Session Module; Authenticate Signin actions
  """
  alias Pitanja.Accounts

  def authenticate(%{"email" => email, "password" => password}) do
    user = Accounts.get_user_by_email(%{email: String.downcase(email)})
    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Bcrypt.dummy_checkpw()
      _ -> Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
    end
  end
end
