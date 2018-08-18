defmodule Blog.Comment do
  use Ecto.Schema

  schema "comments" do
    field :content, :string
    field :posted_at, :utc_datetime
    belongs_to :user, Blog.User
    belongs_to :post, Blog.Post

    timestamps(type: :utc_datetime)
  end
end
