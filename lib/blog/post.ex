defmodule Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Post

  schema "posts" do
    field :title, :string
    field :content, :string
    field :posted_at, :utc_datetime
    belongs_to :user, Blog.User
    has_many :comments, Blog.Comment

    timestamps(type: :utc_datetime)
  end

  def changeset(%Post{} = post, attrs \\ %{}) do
    post
    |> cast(attrs, [:title, :content])
    |> may_put_posted_at()
    |> validate_required([:title, :content, :posted_at])
  end

  defp may_put_posted_at(%{data: %{posted_at: nil}} = changeset) do
    put_change(changeset, :posted_at, DateTime.utc_now())
  end
  defp may_put_posted_at(changeset) do
    changeset
  end
end
