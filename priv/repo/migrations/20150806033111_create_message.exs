defmodule Docs.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text
      add :username, :string
      add :document_id, references(:documents)

      timestamps
    end
    create index(:messages, [:document_id])

  end
end
