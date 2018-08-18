defmodule BlogWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  def context(ctx) do
    dataloader = Dataloader.new()
                 |> Dataloader.add_source(:db, BlogWeb.Dataloader.Database.new())
    Map.put(ctx, :loader, dataloader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
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
        |> Dataloader.load(:db, Blog.User, post.user_id)
        |> on_load(fn loader ->
          user = Dataloader.get(loader, :db, Blog.User, post.user_id)
          {:ok, user}
        end)
      end
    end
    field :comments, list_of(:comment) do
      resolve fn post, _, %{context: %{loader: loader}} ->
        loader
        |> Dataloader.load(:db, {:many, Blog.Comment}, post_id: post.id)
        |> on_load(fn loader ->
          comments = Dataloader.get(loader, :db, {:many, Blog.Comment}, post_id: post.id)
          {:ok, comments}
        end)
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
      resolve fn comment, _, %{context: %{loader: loader}} ->
        loader
        |> Dataloader.load(:db, Blog.Comment, comment.post_id)
        |> on_load(fn loader ->
          post = Dataloader.get(loader, :db, Blog.Comment, comment.post_id)
          {:ok, post}
        end)
      end
    end
    field :user, non_null(:user) do
      resolve fn comment, _, %{context: %{loader: loader}} ->
        loader
        |> Dataloader.load(:db, Blog.User, comment.user_id)
        |> on_load(fn loader ->
          user = Dataloader.get(loader, :db, Blog.User, comment.user_id)
          {:ok, user}
        end)
      end
    end
  end
end
