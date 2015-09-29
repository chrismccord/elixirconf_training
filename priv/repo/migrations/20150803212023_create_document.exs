defmodule Docs.Repo.Migrations.CreateDocument do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :body, :text
      add :title, :string

      timestamps
    end

  end
end
