defmodule RnlHackathon.Repo.Migrations.CreateInterest do
  use Ecto.Migration

  def change do
    create table(:interests) do
      add :user_id, references(:users, on_delete: :nothing)
      add :idea_id, references(:ideas, on_delete: :nothing)

      timestamps
    end
    create index(:interests, [:user_id])
    create index(:interests, [:idea_id])

  end
end
