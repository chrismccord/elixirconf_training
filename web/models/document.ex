defmodule Docs.Document do
  use Docs.Web, :model

  schema "documents" do
    field :body, :string
    field :title, :string
    field :author, :string
    has_many :messages, Docs.Message

    timestamps
  end

  @required_fields ~w(body title)
  @optional_fields ~w(author)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:title, min: 3, max: 255)
  end
end
