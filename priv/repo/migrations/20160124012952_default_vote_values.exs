defmodule RnlHackathon.Repo.Migrations.MakeVoteValueAnInt do
  use Ecto.Migration

  def change do
    alter table(:votes) do
      modify :vote_value, :integer, default: 0
      remove :value
    end
  end
end
