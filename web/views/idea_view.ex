defmodule RnlHackathon.IdeaView do
  use RnlHackathon.Web, :view
  alias RnlHackathon.Idea
  alias RnlHackathon.Vote
  import Ecto
  import Ecto.Query

  # Would rather this check if logged in and check if it's their idea,
  # but having trouble passing @conn
  def can_edit_idea idea, user_id do
    idea.user_id == user_id
  end

  def class_for_vote_buttons idea_id, user_id, val do
    extra_class = case RnlHackathon.Repo.get_by(Vote, user_id: user_id, idea_id: idea_id, vote_value: val) do
      nil -> "btn-default"
      vote -> if val == 1, do: "btn-primary", else: "btn-warning"
    end
    "btn " <> extra_class <> " btn-xs btn-vote"
  end
end
