defmodule Pitanja.Web.Router do
  use Pitanja.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin_api do
    plug Guardian.Plug.VerifyHeader, realm: "Token"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated,
         [handler: Pitanja.Web.SessionController]
  end

  scope "/users", Pitanja.Web do
    pipe_through :api

    post       "/sessions", SessionController, :create
    delete     "/sessions", SessionController, :delete
  end

  scope "/api", Pitanja.Web do
    pipe_through :api

    resources "/users", UserController, only: [:index, :show]
    resources "/chapters", ChapterController, only: [:index, :show]
    resources "/questions", QuestionController, only: [:index, :show]
    resources "/answers", AnswerController, only: [:index, :show]

    get "/questions_by_chapter_id/:id", QuestionController, :list_questions_by_chapter_id
    get "/answers_by_question_id/:id", AnswerController, :list_answers_by_question_id
  end

  scope "/admin_api", Pitanja.Web do
    pipe_through [:api, :admin_api]

    resources "/users", UserController, except: [:new, :edit]
    resources "/chapters", ChapterController, except: [:new, :edit]
    resources "/questions", QuestionController, except: [:new, :edit]
    resources "/answers", AnswerController, except: [:new, :edit]

    post "/question_image/:id", QuestionController, :upload_image
    put "/question_image/:id", QuestionController, :upload_image
    get "/questions_by_chapter_id/:id", QuestionController, :list_questions_by_chapter_id
    get "/answers_by_question_id/:id", AnswerController, :list_answers_by_question_id
  end
end
