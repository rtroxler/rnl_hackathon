defmodule RnlHackathon.InterestTest do
  use RnlHackathon.ModelCase

  alias RnlHackathon.Interest

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Interest.changeset(%Interest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Interest.changeset(%Interest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
