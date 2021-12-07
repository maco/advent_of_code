defmodule AdventOfCode.Day05 do
  def part1(args) do
    parse(args)
    |> Enum.map(&calculate_points(&1, :no_diagonals))
    |> count_dangers()
  end

  def parse(input) do
    String.split(input, ~r"[^0-9]", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
    |> Enum.map(fn [x1, y1, x2, y2] -> [{x1, y1}, {x2, y2}] end)
  end

  def count_dangers(points) do
    points
    |> List.flatten()
    |> Enum.reject(fn point -> point == [] end)
    |> Enum.frequencies()
    |> Enum.filter(fn {_point, freq} -> freq >= 2 end)
    |> Enum.count()
  end

  @doc"""
      iex> AdventOfCode.Day05.calculate_points([{0,9}, {5,9}], :with_diagonals)
      [{0,9},{1,9},{2,9},{3,9},{4,9},{5,9}]

      iex> AdventOfCode.Day05.calculate_points([{7,0}, {7,4}], :with_diagonals)
      [{7,0},{7,1},{7,2},{7,3},{7,4}]

      iex> AdventOfCode.Day05.calculate_points([{9,7}, {7,9}], :with_diagonals)
      [{9,7}, {8,8}, {7,9}]

      iex> AdventOfCode.Day05.calculate_points([{9,7}, {7,9}], :no_diagonals)
      []
  """
  def calculate_points([{x,y1},{x,y2}], _) do
    for y <- y1..y2, do: {x, y}
  end

  def calculate_points([{x1,y},{x2,y}], _) do
    for x <- x1..x2, do: {x, y}
  end

  def calculate_points([{x1, y1}, {x2, y2}], :with_diagonals), do: Enum.zip(x1..x2, y1..y2)

  def calculate_points(_, :no_diagonals), do: []

  def part2(args) do
    parse(args)
    |> Enum.map(&calculate_points(&1, :with_diagonals))
    |> count_dangers()
  end
end
