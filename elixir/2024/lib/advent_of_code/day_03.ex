defmodule AdventOfCode.Day03 do
  def part1(input) do
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, input, capture: :all_but_first)
    |> Enum.reduce(0, fn [x, y], acc -> acc + String.to_integer(x) * String.to_integer(y) end)
  end

  def part2(input) do
    Regex.scan(~r/(mul\(\d{1,3},\d{1,3}\)|don\'t\(\)|do\(\))/, input, capture: :all_but_first)
    |> Enum.reduce({:enabled, 0}, fn
      ["don't()"], {_, acc} ->
        {:disabled, acc}

      ["do()"], {_, acc} ->
        {:enabled, acc}

      ["mul(" <> _vals], {:disabled, acc} ->
        {:disabled, acc}

      ["mul(" <> vals], {:enabled, acc} ->
        product =
          vals
          |> String.trim_trailing(")")
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)
          |> Enum.product()

        {:enabled, acc + product}
    end)
    |> elem(1)
  end
end
