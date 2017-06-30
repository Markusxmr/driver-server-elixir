defmodule Pitanja.Web.UserView do
  use Pitanja.Web, :view
  alias Pitanja.Web.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("show_token.json", %{user: user}) do
    %{user: render_one(user, UserView, "user_token.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      username: ~s(#{user.first_name} #{user.last_name}),
      email: user.email,
      dob: user.dob,
      image: user.avatar}
  end

  def render("user_token.json", %{user: user}) do
    %{email: user.email,
      token: user.token,
      username: ~s(#{user.first_name} #{user.last_name}),
      image: user.avatar}
  end
end
