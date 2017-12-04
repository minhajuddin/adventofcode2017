defmodule Spiral do
  def count_steps(num) do
    {x, y} = find(num)
    abs(x) + abs(y)
  end

  def find(n) do
    generate(n)
    |> Map.get(n)
  end

  def generate(n) do
    {_n, _point, coords} =
      edge_stream()
      |> Enum.take(1500)
      |> Enum.take(n)
      |> Enum.reduce({1, {0, 0}, []}, fn {edge, size}, {n, point, acc} ->
           {{n, point}, edge_coords} = generate_edge(edge, size, point, n)
           {n, point, [edge_coords | acc]}
         end)

    coords
    |> Enum.reduce(%{}, fn edge_coords, acc ->
         Map.merge(acc, Map.new(edge_coords))
       end)
  end

  def edge_stream do
    Stream.zip(stream_edges(), stream_edge_sizes())
  end

  def generate_edge(:bottom, size, {x, y}, n) do
    coords =
      0..(size - 1)
      |> Enum.map(fn idx -> {n + idx, {x + idx, y}} end)

    {coords |> List.last(), coords}
  end

  def generate_edge(:right, size, {x, y}, n) do
    coords =
      0..(size - 1)
      |> Enum.map(fn idx -> {n + idx, {x, y + idx}} end)

    {coords |> List.last(), coords}
  end

  def generate_edge(:top, size, {x, y}, n) do
    coords =
      0..(size - 1)
      |> Enum.map(fn idx -> {n + idx, {x - idx, y}} end)

    {coords |> List.last(), coords}
  end

  def generate_edge(:left, size, {x, y}, n) do
    coords =
      0..(size - 1)
      |> Enum.map(fn idx -> {n + idx, {x, y - idx}} end)

    {coords |> List.last(), coords}
  end

  def stream_edge_sizes do
    Stream.iterate({2, 0}, fn
      {x, 0} -> {x, 1}
      {x, 1} -> {x + 1, 0}
    end)
    |> Stream.map(fn {x, _} -> x end)
  end

  @edges [:bottom, :right, :top, :left]
  def stream_edges do
    Stream.cycle(@edges)
  end
end

ExUnit.start()

defmodule SpiralTest do
  use ExUnit.Case

  import Spiral

  test "gen edge" do
    assert generate_edge(:bottom, 2, {0, 0}, 1) == {{2, {1, 0}}, [{1, {0, 0}}, {2, {1, 0}}]}
    # assert generate_edge(:bottom, 2, {2, 3}) == {{3, 3}, [{2, 3}, {3, 3}]}
    # assert generate_edge(:right, 2, {2, 3}) == {{2, 4}, [{2, 3}, {2, 4}]}
    # assert generate_edge(:top, 2, {2, 3}) == {{1, 3}, [{2, 3}, {1, 3}]}
    # assert generate_edge(:left, 2, {2, 3}) == {{2, 2}, [{2, 3}, {2, 2}]}
  end

  test "edge stream" do
    assert edge_stream() |> Enum.take(1) == [bottom: 2]
    assert edge_stream() |> Enum.take(2) == [bottom: 2, right: 2]
    assert edge_stream() |> Enum.take(3) == [bottom: 2, right: 2, top: 3]
    assert edge_stream() |> Enum.take(4) == [bottom: 2, right: 2, top: 3, left: 3]
    assert edge_stream() |> Enum.take(5) == [bottom: 2, right: 2, top: 3, left: 3, bottom: 4]
  end

  test "generate" do
    assert generate(4) == %{
             1 => {0, 0},
             2 => {1, 0},
             3 => {1, 1},
             4 => {0, 1},
             5 => {-1, 1},
             6 => {-1, 0},
             7 => {-1, -1}
           }
  end

  test "find" do
    assert find(4) == {0, 1}
  end

  test "count_steps" do
    assert count_steps(1) == 0
    assert count_steps(12) == 3
    assert count_steps(23) == 2
    assert count_steps(1024) == 31
    assert count_steps(368078) == 31
  end

end
