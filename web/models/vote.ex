defmodule RnlHackathon.Vote do
  use RnlHackathon.Web, :model

  schema "votes" do
    field :value, :string
    belongs_to :user, RnlHackathon.User
    belongs_to :idea, RnlHackathon.Idea

    timestamps
  end

  @required_fields ~w(value)
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
end
