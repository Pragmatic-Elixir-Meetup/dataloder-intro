defmodule BlogWeb.Dataloader.CommentsCount do
  import Ecto.Query
  def new(), do: Dataloader.KV.new(&load/2)

  def load(_batch_key, post_ids) do
    query = from c in Blog.Comment,
      where: c.post_id in ^MapSet.to_list(post_ids),
      group_by: c.post_id,
      select: {c.post_id, fragment("count(*)")}

    query
    |> Blog.Repo.all()
    |> Map.new()  # %{ 1 => 4, 2 => 1 }
  end
end
