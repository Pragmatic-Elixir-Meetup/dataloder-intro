defmodule BlogWeb.Router do
  use BlogWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  forward "/api", Absinthe.Plug, schema: BlogWeb.Schema
  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BlogWeb.Schema
end
