defmodule Captcha do
  def solve_next_digit(input) do
    digits = Integer.digits(input)
    digits = digits ++ [hd(digits)]
    reduce(digits, 0)
  end

  defp reduce([], acc), do: acc
  defp reduce([a, a | rest], acc), do: reduce([a | rest], a + acc)
  defp reduce([_a | rest], acc), do: reduce(rest, acc)

  def solve_halfway_next(input) do
    digits = Integer.digits(input)
    halfway_len = round(length(digits) / 2)
    {first_half, second_half} = Enum.split(digits, halfway_len)
    first = Enum.zip(first_half, second_half) |> Enum.map(&reduce_pairs/1) |> Enum.sum()
    second = Enum.zip(second_half, first_half) |> Enum.map(&reduce_pairs/1) |> Enum.sum()
    first + second
  end

  defp reduce_pairs({a, a}), do: a
  defp reduce_pairs(_), do: 0
end

ExUnit.start()

defmodule CaptchaTest do
  use ExUnit.Case

  import Captcha

  @tag :skip
  test "solve_next_digit captcha" do
    assert solve_next_digit(1122) == 3
    assert solve_next_digit(1111) == 4
    assert solve_next_digit(1234) == 0
    assert solve_next_digit(91_212_129) == 9
    {input, ""} = File.read!("input.data") |> String.trim() |> Integer.parse()
    assert solve_next_digit(input) == 1182
  end

  test "solve_halfway_next captcha" do
    assert solve_halfway_next(1212) == 6
    assert solve_halfway_next(123_425) == 4
    assert solve_halfway_next(123_123) == 12
    assert solve_halfway_next(12_131_415) == 4
    {input, ""} = File.read!("input.data") |> String.trim() |> Integer.parse()
    assert solve_halfway_next(input) == 1152
  end
end
