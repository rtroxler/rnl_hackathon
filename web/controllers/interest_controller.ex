defmodule RnlHackathon.InterestController do
  use RnlHackathon.Web, :controller
  import Passport.SessionManager, only: [current_user: 1, logged_in?: 1]
  alias RnlHackathon.Interest
  alias RnlHackathon.Idea

  def create(conn, %{"idea_id" => idea_id}) do
    idea = Repo.get!(Idea, idea_id)

    # Kinda hacky, but prevents double posting Interests
    case RnlHackathon.Repo.get_by(Interest, user_id: current_user(conn).id, idea_id: idea.id) do
      nil -> RnlHackathon.Repo.insert!(Interest.changeset(%Interest{}, %{ user_id: current_user(conn).id, idea_id: idea_id }))
      _interest -> ""
    end

    conn
    |> put_flash(:info, "You are now interested in helping with " <> idea.name )
    |> redirect(to: idea_path(conn, :index))
  end

  def delete(conn, %{"idea_id" => idea_id, "id" => _id}) do
    idea = Repo.get!(Idea, idea_id)
    interest = Repo.get_by(Interest, %{user_id: current_user(conn).id, idea_id: idea_id})
    Repo.delete!(interest)

    conn
    |> put_flash(:info, "You are no longer interested in helping with " <> idea.name )
    |> redirect(to: idea_path(conn, :index))
  end
end

