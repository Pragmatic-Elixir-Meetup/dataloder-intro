defmodule BlogWeb.Dataloader.Database do
  def new do
    Dataloader.Ecto.new(Blog.Repo,
      query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
