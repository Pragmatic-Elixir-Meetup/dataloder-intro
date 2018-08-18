defmodule BlogWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  query do
    field :posts, list_of(:post) do
      resolve fn _, _, _ ->
        {:ok, Blog.list_posts()}
      end
    end
  end

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  object :post do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :content, non_null(:string)
    field :posted_at, non_null(:datetime)
    field :user, non_null(:user) do
      resolve fn post, _, _ ->
        query = Ecto.assoc(post, :user)
        {:ok, Blog.Repo.one(query)}
      end
    end
    field :comments, list_of(:comment) do
      resolve fn post, _, _ ->
        query = Ecto.assoc(post, :comments)
        {:ok, Blog.Repo.all(query)}
      end
    end
    field :comments_count, non_null(:integer) do
      resolve fn post, _, _ ->
        import Ecto.Query
        query = from(c in Blog.Comment, where: c.post_id == ^post.id)
        {:ok, Blog.Repo.aggregate(query, :count, :id)}
      end
    end
  end

  object :comment do
    field :id, non_null(:id)
    field :content, non_null(:string)
    field :posted_at, non_null(:datetime)
    field :post, non_null(:post) do
      resolve fn comment, _, _ ->
        query = Ecto.assoc(comment, :post)
        {:ok, Blog.Repo.one(query)}
      end
    end
    field :user, non_null(:user) do
      resolve fn comment, _, _ ->
        query = Ecto.assoc(comment, :user)
        {:ok, Blog.Repo.one(query)}
      end
    end
  end
end
