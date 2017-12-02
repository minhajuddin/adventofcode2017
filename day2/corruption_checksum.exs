defmodule CorruptionChecksum do
  def checksum(spreadsheet) do
    spreadsheet
    |> String.split("\n")
    |> Enum.filter(fn row -> row != "" end)
    |> Enum.map(fn row ->
      {min, max} =
        String.split(row, ~r"\s")
        |> Enum.map(fn col ->
          {col, ""} =
            col
            |> String.trim()
            |> Integer.parse()

            col
        end)
        |> Enum.min_max
        max - min
    end)
    |> Enum.sum()
  end

  def evenly_divide(spreadsheet) do
    spreadsheet
    |> String.split("\n")
    |> Enum.filter(fn row -> row != "" end)
    |> Enum.map(fn row ->
      sorted_row =
        String.split(row, ~r"\s")
        |> Enum.map(fn col ->
         {col, ""} =
            col
            |> String.trim()
            |> Integer.parse()

            col
        end)
        |> Enum.sort

        reverse_sorted_row = sorted_row |> Enum.reverse

        reverse_sorted_row
        |> Enum.find_value(fn num ->
          den = Enum.find(sorted_row, fn den ->
            rem(num, den) == 0 && num != den
          end)
          if den do
            div(num, den)
          end
        end)
    end)
    |> Enum.sum()
  end
end

ExUnit.start()

defmodule CorruptionChecksumTest do
  use ExUnit.Case

  import CorruptionChecksum

  test "checksum" do
    cs =
      checksum("""
5 1 9 5
7 5 3
2 4 6 8
""")

    assert cs == 18
  end

  test "checksum with input" do
    input = File.read!("input.data")
    assert checksum(input) == 45351
  end

  test "evenly_divide" do
    res = evenly_divide """
5 9 2 8
9 4 7 3
3 8 6 5
    """
    assert res == 9
  end

  test "evenly_divide with input" do
    input = File.read!("input.data")
    assert evenly_divide(input) == 275
  end

end
