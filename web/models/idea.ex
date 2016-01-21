defmodule RnlHackathon.Idea do
  use RnlHackathon.Web, :model

  schema "ideas" do
    field :name, :string
    field :description, :string
    belongs_to :user, RnlHackathon.User

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
end
