defmodule RnlHackathon.IdeaController do
  use RnlHackathon.Web, :controller
  import Passport.SessionManager, only: [current_user: 1, logged_in?: 1]

  alias RnlHackathon.Idea

  plug :scrub_params, "idea" when action in [:create, :update]

  def index(conn, _params) do
    token = case current_user(conn) do
      false -> nil
      user -> Phoenix.Token.sign(conn, "user socket", user.id)
    end

    query = from i in Idea, where: is_nil(i.completed_at)
    ideas = Repo.all(query) |> Repo.preload([:user, :votes])
    conn
    |> assign(:user_token, token)
    |> render(:index, ideas: ideas)
  end

  def completed_index(conn, _params) do
    token = case current_user(conn) do
      false -> nil
      user -> Phoenix.Token.sign(conn, "user socket", user.id)
    end

    query = from i in Idea, where: not(is_nil(i.completed_at))
    ideas = Repo.all(query) |> Repo.preload([:user, :votes])
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
        RnlHackathon.Endpoint.broadcast!("ideas:index", "ideas_changed", %{idea: idea_params})
        conn
        |> put_flash(:info, "Idea created successfully.")
        |> redirect(to: idea_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    idea = Idea |> Repo.get!(id) |> Repo.preload([:user, :interests, :votes])

    query = from(int in assoc(idea, :interests),
                 left_join: user in assoc(int, :user),
                 select: user)
    users = Repo.all(query)

    conn
    |> assign(:idea_description, Earmark.to_html(idea.description))
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

    RnlHackathon.Endpoint.broadcast!("ideas:index", "ideas_changed", %{})
    conn
    |> put_flash(:info, "Idea deleted successfully.")
    |> redirect(to: idea_path(conn, :index))
  end

  def mark_complete(conn, %{"idea_id" => id}) do
    idea = Repo.get!(Idea, id)

    changeset = Idea.changeset(idea, %{"completed_at" => :calendar.local_time,
                                       "completed_by_id" => current_user(conn).id})

    case Repo.update(changeset) do
      {:ok, idea} ->
        conn
        |> put_flash(:info, "Idea has been marked completed.")
        |> redirect(to: idea_path(conn, :show, idea))
      {:error, changeset} ->
        render(conn, "edit.html", idea: idea, changeset: changeset)
    end
  end
end
