defmodule Maze do
  def count_steps(seq, strategy) do
    seq =
      seq
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index(0)
      |> Enum.map(fn {offset, idx} -> {idx, offset} end)
      |> Map.new()

    find_exit(0, seq, 0, strategy)
  end

  def find_exit(offset, seq, jumps, strategy) do
    if new_offset = seq[offset] do
      seq = %{seq | offset => adjust_for_strategy(seq[offset], strategy)}
      find_exit(offset + new_offset, seq, jumps + 1, strategy)
    else
      {:ok, jumps}
    end
  end

  defp adjust_for_strategy(offset, :positive), do: offset + 1
  defp adjust_for_strategy(offset, :strange) when offset < 3, do: offset + 1
  defp adjust_for_strategy(offset, :strange), do: offset - 1
end

ExUnit.start()

defmodule MazeTest do
  use ExUnit.Case
  import Maze

  describe "count_steps" do
    test "input" do
      assert count_steps("""
             0
             3
             0
             1
             -3
             """, :positive) == {:ok, 5}
    end

    test "file input" do
      {:ok, steps} =
        "input.data"
        |> File.read!()
        |> count_steps(:positive)

      assert steps == 375_042
    end
  end

  describe "twisty" do
    test "input" do
      assert count_steps("""
             0
             3
             0
             1
             -3
             """, :strange) == {:ok, 10}
    end

    test "file input" do
      {:ok, steps} =
        "input.data"
        |> File.read!()
        |> count_steps(:strange)

      assert steps == 375_042
    end

  end
end
