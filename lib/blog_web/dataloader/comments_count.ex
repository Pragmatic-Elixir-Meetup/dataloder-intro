defmodule BlogWeb.Dataloader.CommentsCount do
  import Ecto.Query
  def new(), do: Dataloader.KV.new(&load/2)

  def load(_batch_key, posts) do
    post_ids = Enum.map(posts, & &1.id)
    comments_counts = comments_counts(post_ids)

    Enum.reduce(posts, %{}, fn post, acc ->
      Map.put(acc, post, Map.get(comments_counts, post.id) || 0)
    end)
  end

  def comments_counts(post_ids) do
    query = from c in Blog.Comment,
      where: c.post_id in ^post_ids,
      group_by: c.post_id,
      select: {c.post_id, fragment("count(*)")}

    query
    |> Blog.Repo.all()
    |> Map.new()  # %{ 1 => 4, 2 => 1 }
  end
end
