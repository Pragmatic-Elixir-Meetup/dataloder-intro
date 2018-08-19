defmodule BlogWeb.LoaderTest do
  use ExUnit.Case

  alias BlogWeb.Loader

  setup do
    load_function = fn keys -> Enum.reduce(keys, %{}, fn key, acc ->
      Map.put(acc, key, key) end)
    end

    {:ok, loader: Loader.new(load_function)}
  end

  test "load/2 puts the load key to the queue", %{loader: loader} do
    loader = Loader.load(loader, 1)
    assert MapSet.member?(loader.queue, 1)
  end

  test "run/1 executes the load function and caches the result", %{loader: loader} do
    loader = loader
             |> Loader.load(1)
             |> Loader.load(2)
             |> Loader.run()

    assert loader.results == %{ 1 => 1, 2 => 2 }
  end

  test "get/2 reads result from the cache", %{loader: loader} do
    loader = loader
             |> Loader.load(1)
             |> Loader.load(2)
             |> Loader.run()

    assert Loader.get(loader, 1) == 1
  end

  test "pending_jobs?/1 detects pending job", %{loader: loader} do
    loader = loader
             |> Loader.load(1)
    assert Loader.pending_jobs?(loader)

    loader = Loader.run(loader)
    refute Loader.pending_jobs?(loader)
  end
end
