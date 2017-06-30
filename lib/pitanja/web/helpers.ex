defmodule Pitanja.Web.Helpers do
  @moduledoc """
  Helpers Module
  """

  def custom_url_body do
    case Application.get_env(:pitanja, :environment) do
      :dev ->
         "http://localhost:4000"
      :prod ->
        "http://some-url.com:4000"
      _ ->
        "http://localhost:4000"
    end
  end
end
