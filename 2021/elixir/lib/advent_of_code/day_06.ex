defmodule AdventOfCode.Day06 do
  def part1(args) do
    fish = parse(args)

    Enum.reduce(1..80, fish, fn _day, fishes ->
      Enum.map(fishes, fn
        0 -> [6, 8]
        x -> x - 1
      end)
      |> List.flatten()
    end)
    |> Enum.count()
  end

  # part1 was super not optimized enough. The idea to use frequencies is courtesy of Guy Argo
  def part2(args) do
    fish =
      parse(args)
      |> Enum.frequencies()

    Enum.reduce(1..256, fish, fn _day, fishes ->
      {zeroes, others} = Map.pop(fishes, 0, 0)

      Enum.reduce(0..8, others, fn
        8, acc ->
          Map.put(acc, 8, zeroes)

        6, acc ->
          Map.put(acc, 6, zeroes + Map.get(others, 7, 0))

        remaining, acc ->
          Map.put(acc, remaining, Map.get(others, remaining + 1, 0))
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  defp parse(input), do: String.trim(input) |> String.split(",") |> Enum.map(&String.to_integer/1)
end
