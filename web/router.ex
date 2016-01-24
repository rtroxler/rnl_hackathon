defmodule RnlHackathon.Router do
  use RnlHackathon.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RnlHackathon do
    pipe_through :browser # Use the default browser stack

    get "/", IdeaController, :index

    resources "/ideas", IdeaController

    # For Passport
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete

    get "/signup", RegistrationController, :new
    post "/signup", RegistrationController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", RnlHackathon do
  #   pipe_through :api
  # end
end
