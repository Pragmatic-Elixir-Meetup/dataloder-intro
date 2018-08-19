defmodule BlogWeb.Middleware.Loader do
  @behaviour Absinthe.Middleware

  alias BlogWeb.Loader

  @impl true
  def call(%{state: :unresolved} = resolution, {loader, callback}) do
    if Loader.pending_jobs?(loader) do
      %{
        resolution
        | context: Map.put(resolution.context, :loader, loader),
        state: :suspended,
        middleware: [{__MODULE__, callback} | resolution.middleware]
      }
    else
      get_result(resolution, callback)
    end
  end

  @impl true
  def call(%{state: :suspended} = resolution, callback) do
    get_result(resolution, callback)
  end

  def on_load(loader, callback) do
    {:middleware, __MODULE__, {loader, callback}}
  end

  defp get_result(resolution, callback) do
    value = callback.(resolution.context.loader)
    Absinthe.Resolution.put_result(resolution, value)
  end
end
