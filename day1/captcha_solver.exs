defmodule Captcha do
  def solve(input) do
    digits = Integer.digits(input)
    digits = digits ++ [hd(digits)]
    reduce(digits, 0)
  end

  defp reduce([], acc), do: acc
  defp reduce([a, a | rest], acc), do: reduce([a | rest], a + acc)
  defp reduce([_a | rest], acc), do: reduce(rest, acc)
end

ExUnit.start()

defmodule CaptchaTest do
  use ExUnit.Case

  import Captcha

  test "solve captcha" do
    assert solve(1122) == 3
    assert solve(1111) == 4
    assert solve(1234) == 0
    assert solve(91212129) == 9
    {input, ""} = File.read!("input.data") |> String.strip |> Integer.parse
    assert solve(input) == 1182
  end
end
