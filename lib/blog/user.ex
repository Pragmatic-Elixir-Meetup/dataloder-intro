defmodule Blog.User do
  use Ecto.Schema

  schema "users" do
    field :name, :string
    timestamps(type: :utc_datetime)
  end
end
