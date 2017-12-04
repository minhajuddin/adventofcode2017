defmodule Passphrase do
  def anagram_valid?(passphrase) do
    sorted_internal_words =
      passphrase
      |> String.split(~r(\s))
      |> Enum.map(fn x ->
           x |> to_charlist |> Enum.sort()
         end)
      |> Enum.sort()

    sorted_internal_words == Enum.uniq(sorted_internal_words)
  end

  def valid?(passphrase) do
    sorted_words =
      passphrase
      |> String.split(~r(\s))
      |> Enum.sort()

    sorted_words == Enum.uniq(sorted_words)
  end
end

ExUnit.start()

defmodule PassphraseTest do
  use ExUnit.Case

  import Passphrase

  test "valid?" do
    assert valid?("aa bb cc dd ee")
    refute valid?("aa bb cc dd aa")
    assert valid?("aa bb cc dd aaa")
  end

  test "file input" do
    cnt =
      File.stream!("input.data")
      |> Enum.map(fn line ->
           if valid?(line) do
             1
           else
             0
           end
         end)
      |> Enum.sum()

    assert cnt == 337
  end

  describe "anagram_valid?" do
    test "valid?" do
      assert anagram_valid?("abcde fghij")
      refute anagram_valid?("abcde xyz ecdab")
      assert anagram_valid?("a ab abc abd abf abj")
      assert anagram_valid?("iiii oiii ooii oooi oooo")
      refute anagram_valid?("oiii ioii iioi iiio")
    end

    test "file input" do
      cnt =
        File.stream!("input.data")
        |> Enum.map(fn line ->
             if anagram_valid?(line) do
               1
             else
               0
             end
           end)
        |> Enum.sum()

      assert cnt == 231
    end
  end
end
