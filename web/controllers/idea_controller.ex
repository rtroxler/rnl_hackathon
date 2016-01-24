defmodule RnlHackathon.IdeaController do
  use RnlHackathon.Web, :controller
  import Passport.SessionManager, only: [current_user: 1, logged_in?: 1]

  alias RnlHackathon.Idea
  alias RnlHackathon.Interest

  plug :scrub_params, "idea" when action in [:create, :update]

  def index(conn, _params) do
    token = case current_user(conn) do
      false -> nil
      user -> Phoenix.Token.sign(conn, "user socket", user.id)
    end

    ideas = Idea |> Repo.all |> Repo.preload [:user, :votes]
    conn
    |> assign(:user_token, token)
    |> render(:index, ideas: ideas)
  end

  def new(conn, _params) do
    changeset = Idea.changeset(%Idea{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"idea" => idea_params}) do
    changeset = Idea.changeset(%Idea{}, idea_params)

    case Repo.insert(changeset) do
      {:ok, _idea} ->
        conn
        |> put_flash(:info, "Idea created successfully.")
        |> redirect(to: idea_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    idea = Idea |> Repo.get!(id) |> Repo.preload [:user, :interests]

    query = from(int in assoc(idea, :interests),
                 left_join: user in assoc(int, :user),
                 select: user)
    users = Repo.all(query)

    conn
    |> assign(:interested_users, users)
    |> render(:show, idea: idea)
  end

  def edit(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)
    changeset = Idea.changeset(idea)
    render(conn, "edit.html", idea: idea, changeset: changeset)
  end

  def update(conn, %{"id" => id, "idea" => idea_params}) do
    idea = Repo.get!(Idea, id)
    changeset = Idea.changeset(idea, idea_params)

    case Repo.update(changeset) do
      {:ok, idea} ->
        conn
        |> put_flash(:info, "Idea updated successfully.")
        |> redirect(to: idea_path(conn, :show, idea))
      {:error, changeset} ->
        render(conn, "edit.html", idea: idea, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(idea)

    conn
    |> put_flash(:info, "Idea deleted successfully.")
    |> redirect(to: idea_path(conn, :index))
  end
end
