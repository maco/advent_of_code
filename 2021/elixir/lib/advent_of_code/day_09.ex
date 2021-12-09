defmodule AdventOfCode.Day09 do
  def part1(args) do
    raw_data = String.split(args, "\n", trim: true)
    |> Enum.map(fn line ->
      String.graphemes(line)
      |> Enum.map(fn char ->
        String.to_integer(char)
      end)
    end)
    generate_map(raw_data)
    |> find_low_points()
    |> Enum.map(& elem(&1, 1) + 1)
    |> Enum.sum()
  end

  @doc"""
      iex> map = %{{0, 0} => 1, {0, 1} => 6, {0, 2} => 2, {1,0} => 4, {1,1} => 2, {1,2} => 6, {2,0} => 7, {2,1} => 8, {2,2} => 2}
      iex> AdventOfCode.Day09.find_low_points(map)
      [{{0,0}, 1}, {{0,2}, 2}, {{1,1}, 2}, {{2,2}, 2}]
  """
  def find_low_points(map) do
    Enum.filter(map, fn {{row, col}, this} ->
      above = Map.get(map, {row - 1, col}, nil)
      below = Map.get(map, {row + 1, col}, nil)
      left = Map.get(map, {row, col - 1}, nil)
      right = Map.get(map, {row, col + 1}, nil)

      this < above and this < below and this < left and this < right
    end)
  end

  @doc"""
      iex> AdventOfCode.Day09.generate_map([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
      %{{0, 0} => 1, {0, 1} => 2, {0, 2} => 3, {1,0} => 4, {1,1} => 5, {1,2} => 6, {2,0} => 7, {2,1} => 8, {2,2} => 9}
  """
  def generate_map(data) do
    {_, map} = Enum.reduce(data, {0, %{}}, fn row, {row_num, map} ->
      {_, row_data} = Enum.reduce(row, {0, %{}}, fn point, {col_num, minimap} ->
        {col_num + 1, Map.put(minimap, {row_num, col_num}, point)}
      end)
      map_data = Map.merge(map, row_data)
      {row_num + 1, map_data}
    end)

    map
  end

  def part2(args) do
  end
end
