defmodule AdventOfCode.Day01 do
  def part1(input) do
    [list1, list2] =
      input
      |> String.trim
      |> String.split("\n")
      |> Enum.reduce([[], []],
        fn line, [acc1, acc2] ->
          [first, second] = String.split(line)
          [[String.to_integer(first) | acc1], [String.to_integer(second) | acc2]]
        end)
      |> Enum.map(fn list -> Enum.sort(list) end)

    Enum.zip_with(list1, list2, fn first, second -> abs(first - second) end)
    |> Enum.sum
  end

  def part2(_args) do
  end
end
