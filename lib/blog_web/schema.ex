defmodule BlogWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  query do
    field :posts, list_of(:post)
  end

  object :post do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :content, non_null(:string)
    field :posted_at, non_null(:datetime)
    field :comments, list_of(:comment)
  end

  object :comment do
    field :id, non_null(:id)
    field :content, non_null(:string)
    field :posted_at, non_null(:datetime)
  end
end
