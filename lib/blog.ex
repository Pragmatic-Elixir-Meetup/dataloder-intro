defmodule Blog do
  alias Blog.{Repo, Post}

  def list_posts do
    Repo.all(Post)
  end

  def create_post(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end
end
