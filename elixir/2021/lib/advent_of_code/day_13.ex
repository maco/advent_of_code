defmodule AdventOfCode.Day13 do
  def part1(args) do
    {dots, [first | _instructions]} = parse(args)
    case first do
      {"y", n} -> fold_h(dots, n)
      {"x", n} -> fold_v(dots, n)
    end
    |> Enum.count()
  end

  def part2(args) do
    {dots, instructions} = parse(args)

    Enum.reduce(instructions, dots, fn rule, set ->
      case rule do
        {"y", n} -> fold_h(set, n)
        {"x", n} -> fold_v(set, n)
      end
    end)
    |> print()
  end

  def print(dots) do
    max_x = Enum.max_by(dots, fn [x, _y] -> x end) |> List.first()
    max_y = Enum.max_by(dots, fn [_x, y] -> y end) |> List.last()

    for y <- 0..max_y do
      for x <- 0..max_x do
        if x == 0 do
          IO.puts("\n")
        end
        case MapSet.member?(dots, [x, y]) do
          true -> IO.write("# ")
          false -> IO.write(". ")
        end
      end
    end
    IO.puts("\n\n")
    dots
  end

  def fold_h(dots, line) do
    Enum.reduce(dots, MapSet.new(), fn [x, y], set ->
      if y < line do
        MapSet.put(set, [x, y])
      else
        MapSet.put(set, [x, y -  2 * (y - line)])
      end
    end)
  end

  def fold_v(dots, line) do
    Enum.reduce(dots, MapSet.new(), fn [x, y], set ->
      if x < line do
        MapSet.put(set, [x, y])
      else
        MapSet.put(set, [x -  2 * (x - line), y])
      end
    end)
  end

  def parse(input) do
    [dots, instructions] = String.split(input, "\n\n", trim: true)
    dots = String.split(dots, "\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ",")
      |> Enum.map(&String.to_integer(&1))
    end)
    |> MapSet.new()

    instructions = String.split(instructions, "\n", trim: true)
    |> Enum.map(fn "fold along " <> rule ->
      String.split(rule, "=")
      |> then(fn [direction, num] -> {direction, String.to_integer(num)} end)
    end)
    {dots, instructions}
  end
end
