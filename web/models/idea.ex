defmodule RnlHackathon.Idea do
  use RnlHackathon.Web, :model
  alias RnlHackathon.Repo
  import Ecto
  import Ecto.Query

  schema "ideas" do
    field :name, :string
    field :description, :string
    belongs_to :user, RnlHackathon.User
    has_many :votes, RnlHackathon.Vote

    timestamps
  end

  @required_fields ~w(name description user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def vote_count(idea) do
    query = from v in assoc(idea, :votes), select: sum(v.vote_value)
    Repo.one(query)
  end
end
