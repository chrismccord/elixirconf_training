defmodule Docs.Repo.Migrations.AddAuthorToDocuments do
  use Ecto.Migration

  def change do
    alter table(:documents) do
      add :author, :string
    end
  end
end
