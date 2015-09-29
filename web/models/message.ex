defmodule Docs.Message do
  use Docs.Web, :model

  schema "messages" do
    field :body, :string
    field :username, :string
    belongs_to :document, Docs.Document

    timestamps
  end

  @required_fields ~w(body)
  @optional_fields ~w(username)

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
