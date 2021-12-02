defmodule AdventOfCode.Day02 do
  def part1(args) do
    {horizontal, depth} =
      args
      |> parse()
      |> Enum.reduce({0, 0}, fn
        ["up", distance], {horizontal, depth} ->
          {horizontal, depth - distance}

        ["down", distance], {horizontal, depth} ->
          {horizontal, depth + distance}

        ["forward", distance], {horizontal, depth} ->
          {horizontal + distance, depth}
      end)

    horizontal * depth
  end

  def part2(args) do
    {horizontal, depth, _aim} =
      args
      |> parse()
      |> Enum.reduce({0, 0, 0}, fn
        ["down", distance], {horizontal, depth, aim} ->
          {horizontal, depth, aim + distance}

        ["up", distance], {horizontal, depth, aim} ->
          {horizontal, depth, aim - distance}

        ["forward", distance], {horizontal, depth, aim} ->
          {horizontal + distance, depth + aim * distance, aim}
      end)

    horizontal * depth
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [direction, num] -> [direction, String.to_integer(num)] end)
  end
end
