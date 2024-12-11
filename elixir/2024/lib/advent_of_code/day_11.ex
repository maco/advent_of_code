defmodule AdventOfCode.Day11 do
  def part1(input) do
    stones = input |> String.split() |> Enum.map(&String.to_integer/1)

    Enum.reduce(0..24, stones, fn _, acc ->
      blink(acc)
    end)
    |> Enum.count()
  end

  def part2(_args) do
  end

  def blink(stones) do
    Enum.reduce(stones, [], fn
      0, acc ->
        [1 | acc]

      stone, acc ->
        digits = Integer.digits(stone)
        length = length(digits)

        case rem(length, 2) do
          0 ->
            [left, right] =
              digits
              |> Enum.split(Integer.floor_div(length, 2))
              |> Tuple.to_list()
              |> Enum.map(&Integer.undigits/1)

            [right, left | acc]

          _ ->
            [stone * 2024 | acc]
        end
    end)
    |> Enum.reverse()
  end
end
