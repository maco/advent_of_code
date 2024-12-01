defmodule AdventOfCode.Day01 do
  import AdventOfCode.Parsing

  def part1(input) do
    [list1, list2] =
      input
      |> parse_columns_ints()
      |> Enum.map(fn list -> Enum.sort(list) end)

    Enum.zip_with(list1, list2, fn first, second -> abs(first - second) end)
    |> Enum.sum
  end



  def part2(input) do
    [list1, list2] =
      input
      |> parse_columns_ints()

    list2_freqs = Enum.frequencies((list2))

    Enum.reduce(list1, 0,
      fn num, acc ->
        acc + num * Map.get(list2_freqs, num, 0)
      end)
  end
end
