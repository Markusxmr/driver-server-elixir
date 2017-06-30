defmodule Pitanja.Web.QuestionImage do
  use Arc.Definition
  use Arc.Ecto.Definition
  import Pitanja.Web.Helpers, only: [custom_url_body: 0]

  # Include ecto support (requires package arc_ecto installed):
  # use Arc.Ecto.Definition

  @acl :public_read
  @versions [:original]

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Whitelist file extensions:
  # def validate({file, _}) do
  #   ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  # end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  # end

  # Override the persisted filenames:
  # def filename(version, _) do
  #   version
  # end

  def filename(version, {file, _scope}), do: "#{version}-#{file.file_name}"

  # Override the storage directory:
  # def storage_dir(version, {file, scope}) do
  #   "uploads/user/avatars/#{scope.id}"
  # end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  def storage_dir(_, {_file, question_image}) do
    "uploads/question_images/#{question_image.id}/question_image/"
  end

  def default_url(:original) do
    custom_url_body()
  end

  def custom_url do
    custom_url_body()
  end

  def mod_url(file) do
    case Mix.env do
      :dev ->
        "http://localhost:4000/uploads/original-#{file}.jpg"
      :prod ->
        "http://some-url.com:4000/uploads/original-#{file}.jpg"
      _ ->
        "http://localhost:4000/uploads/original-#{file}.jpg"
    end
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
