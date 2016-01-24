defmodule RnlHackathon.RegistrationController do
  use RnlHackathon.Web, :controller

  alias RnlHackathon.User
  alias Passport.RegistrationManager
  alias Passport.SessionManager

  def new(conn, _params) do
    user = User.changeset(%User{})
    conn
    |> render("new.html", user: user)
  end

  def create(conn, %{"registration" => registration_params}) do
    #require IEx
    #IEx.pry
    case RegistrationManager.register(registration_params) do
      {:ok, changeset} -> conn
         |> put_flash(:info, "Registration success")
         |> login(registration_params)
      {:error, changeset}-> conn
         |> render("new.html", user: changeset)
    end
  end

  def login(conn, params) do
    case SessionManager.login(conn, params) do
      {:ok, conn, user} ->
        conn
        |> put_flash(:info, "Logged in")
        |> redirect(to: idea_path(conn, :index))
      {:error, conn} ->
        conn
        |> put_flash(:info, "Registered, but error logging in?")
        |> render(:new)
    end
  end
end
