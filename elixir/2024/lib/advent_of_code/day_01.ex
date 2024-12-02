defmodule AdventOfCode.Day01 do
  import AdventOfCode.Parsing

  def part1(input) do
    input
    |> parse_columns_ints
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip_with(fn [num1, num2] -> abs(num1 - num2) end)
    |> Enum.sum()
  end

  def part2(input) do
    [list1, list2] = parse_columns_ints(input)
    freqs = Enum.frequencies(list2)

    Enum.reduce(list1, 0, fn val, acc -> val * Map.get(freqs, val, 0) + acc end)
  end
end
