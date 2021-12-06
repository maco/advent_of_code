defmodule AdventOfCode.Day06 do
  def part1(args) do
    fish = parse(args)
    Enum.reduce(1..80, fish, fn _day, fishes ->
      Enum.map(fishes, fn
        0 ->
          [6, 8]
        x ->
          x - 1
      end)
      |> List.flatten()
    end)
    |> Enum.count()
  end

  def part2(args) do
  end

  defp parse(input), do: String.trim(input) |> String.split(",") |> Enum.map(&String.to_integer/1)
end
