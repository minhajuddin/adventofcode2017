
defmodule Captcha do
  def solve(n) do
    digits = Integer.digits(n)
    digits = digits ++ [hd(digits)]

    Enum.zip(digits, tl(digits))
    |> IO.inspect(label: "zipped")
    |> Enum.map(fn {f, s} ->
         if f == s do
           f
         else
           0
         end
       end)
    |> IO.inspect(label: "mapped")
    |> Enum.sum()
    |> IO.inspect(label: "sum")
  end
end

ExUnit.start()

defmodule CaptchaTest do
  use ExUnit.Case

  test "solve" do
    assert Captcha.solve(1122) == 3
    assert Captcha.solve(1111) == 4
    assert Captcha.solve(1234) == 0

    assert "~/advent/day1/input.data"
           |> Path.expand()
           |> File.read!()
           |> String.strip()
           |> String.to_integer()
           |> Captcha.solve() == 1182
  end
end
