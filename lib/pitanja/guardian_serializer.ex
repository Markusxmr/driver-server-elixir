defmodule Pitanja.GuardianSerializer do
  @moduledoc false

  @behaviour Guardian.Serializer

  alias Pitanja.Accounts
  alias Pitanja.Accounts.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Invalid user"}

  def from_token("User:" <> id), do: {:ok, Accounts.get_user!(id)}
  def from_token(_), do: {:error, "Invalid user"}
end