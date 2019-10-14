defmodule RnlHackathon.IdeaChannel do
  use RnlHackathon.Web, :channel
  alias RnlHackathon.Vote
  alias RnlHackathon.Idea

  def join("ideas:index", _params, socket) do
    {:ok, socket.assigns[:user], socket}
  end

  def handle_in("new_vote", %{"body" => body}, socket) do
    user_id = socket.assigns[:user]
    idea_id = body["idea_id"]

    case RnlHackathon.Repo.get_by(Vote, user_id: user_id, idea_id: idea_id) do
      nil ->
        changeset = Vote.changeset(%Vote{}, %{ user_id: user_id, idea_id: idea_id, vote_value: body["value"]})
        RnlHackathon.Repo.insert!(changeset)
      vote ->
        updated_vote = %{ vote | vote_value: body["value"] }
        RnlHackathon.Repo.update!(updated_vote)
    end

    idea = Repo.get(Idea, idea_id)
    broadcast! socket, "vote_count_update", %{idea_id: idea_id, vote_count: Idea.vote_count(idea)}

    # broadcast vote update for idea_id, rather than new_vote
    # have handle_out listen for vote_count_update, and in socket.js listen for that and update the idea's vote value
    {:noreply, socket}
  end

end
