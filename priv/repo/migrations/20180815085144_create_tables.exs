defmodule Blog.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create table(:posts) do
      add :title, :string, null: false
      add :content, :text, null: false
      add :user_id, references(:users, on_delete: :nilify_all)
      add :posted_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:comments) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :content, :text, null: false
      add :user_id, references(:users, on_delete: :nilify_all)
      add :posted_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
