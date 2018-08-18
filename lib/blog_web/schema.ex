defmodule BlogWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  def context(ctx) do
    dataloader = Dataloader.new()
                 |> Dataloader.add_source(:db, BlogWeb.Dataloader.Database.new())
                 |> Dataloader.add_source(:comments_count, BlogWeb.Dataloader.CommentsCount.new())

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
    field :user, non_null(:user), resolve: dataloader(:db)
    field :comments, list_of(:comment), resolve: dataloader(:db)
    field :comments_count, non_null(:integer), resolve: dataloader(:comments_count)
  end

  object :comment do
    field :id, non_null(:id)
    field :content, non_null(:string)
    field :posted_at, non_null(:datetime)
    field :post, non_null(:post), resolve: dataloader(:db)
    field :user, non_null(:user), resolve: dataloader(:db)
  end
end
