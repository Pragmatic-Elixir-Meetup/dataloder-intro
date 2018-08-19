defmodule BlogWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  def batch_load_user(user_ids) do
    import Ecto.Query
    query = from(u in Blog.User, where: u.id in ^MapSet.to_list(user_ids), select: { u.id, u })

    query
    |> Blog.Repo.all()
    |> Map.new()
  end

  def context(ctx) do
    loader = BlogWeb.Loader.new(&batch_load_user/1)
    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [BlogWeb.Plugin.Loader | Absinthe.Plugin.defaults()]
  end

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
      resolve fn post, _, %{context: %{loader: loader}} ->
        loader
        |> BlogWeb.Loader.load(post.user_id)
        |> BlogWeb.Middleware.Loader.on_load(fn loader ->
          user = BlogWeb.Loader.get(loader, post.user_id)
          {:ok, user}
        end)
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
