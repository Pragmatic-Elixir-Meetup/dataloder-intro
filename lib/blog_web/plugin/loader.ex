defmodule BlogWeb.Plugin.Loader do
  @behaviour Absinthe.Plugin

  alias BlogWeb.Loader

  @impl true
  def before_resolution(%{context: context} = exec) do
    context = %{context | loader: Loader.run(context.loader)}
    %{exec | context: context}
  end

  @impl true
  def after_resolution(exec) do
    exec
  end

  @impl true
  def pipeline(pipeline, %{context: %{loader: loader}}) do
    case Loader.pending_jobs?(loader) do
      true ->
        [Absinthe.Phase.Document.Execution.Resolution | pipeline]
      _ ->
        pipeline
    end
  end
end
