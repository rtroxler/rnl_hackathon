defmodule RnlHackathon.Repo.Migrations.MakeVoteValueAnInt do
  use Ecto.Migration

  def change do
    alter table(:votes) do
      add :vote_value, :integer
    end
  end
end
