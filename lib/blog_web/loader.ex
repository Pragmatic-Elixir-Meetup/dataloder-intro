defmodule BlogWeb.Loader do
  alias __MODULE__

  defstruct [
    :load_function,
    queue: MapSet.new(),
    results: %{},
  ]

  def new(load_function) do
    %Loader{load_function: load_function}
  end

  def load(loader, key) do
    IO.puts("Loader loads #{key}")
    update_in(loader.queue, fn queue ->
      MapSet.put(queue, key)
    end)
  end

  def run(loader) do
    IO.puts("Running loader with #{MapSet.to_list(loader.queue) |> inspect}")
    %{ loader |
      queue: MapSet.new(),
      results: loader.load_function.(loader.queue)
      }
  end

  def pending_jobs?(loader) do
    MapSet.size(loader.queue) > 0
  end

  def get(loader, key) do
    Map.get(loader.results, key)
  end
end
