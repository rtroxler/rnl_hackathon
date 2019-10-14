defmodule RnlHackathon.Repo.Migrations.AddArchivedToIdeas do
  use Ecto.Migration

  def change do
    alter table(:ideas) do
      add :archived_at, :naive_datetime
    end
  end
end
