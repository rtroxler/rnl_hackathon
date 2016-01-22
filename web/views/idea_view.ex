defmodule RnlHackathon.IdeaView do
  use RnlHackathon.Web, :view
  alias RnlHackathon.Idea

  # Would rather this check if logged in and check if it's their idea,
  # but having trouble passing @conn
  def can_edit_idea idea, user_id do
    idea.user_id == user_id
  end
end
