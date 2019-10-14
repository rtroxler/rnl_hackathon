defmodule RnlHackathon.Repo.Migrations.AddCompletedToIdeas do
  use Ecto.Migration

  def change do
    alter table(:ideas) do
      add :completed_at, :naive_datetime
      add :completed_by_id, :integer
    end
  end
end
