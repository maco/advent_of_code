defmodule AdventOfCode.Day09 do
  def part1(args) do
    parse(args)
    |> generate_map()
    |> find_low_points()
    |> Enum.map(&(elem(&1, 1) + 1))
    |> Enum.sum()
  end

  @doc """
      iex> map = %{{0, 0} => 1, {0, 1} => 6, {0, 2} => 2, {1,0} => 4, {1,1} => 2, {1,2} => 6, {2,0} => 7, {2,1} => 8, {2,2} => 2}
      iex> AdventOfCode.Day09.find_low_points(map)
      [{{0,0}, 1}, {{0,2}, 2}, {{1,1}, 2}, {{2,2}, 2}]
  """
  def find_low_points(map) do
    Enum.filter(map, fn {{row, col}, this} ->
      [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
      |> Enum.all?(fn point -> Map.get(map, point, nil) > this end)
    end)
  end

  @doc """
      iex> AdventOfCode.Day09.generate_map([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
      %{{0, 0} => 1, {0, 1} => 2, {0, 2} => 3, {1,0} => 4, {1,1} => 5, {1,2} => 6, {2,0} => 7, {2,1} => 8, {2,2} => 9}
  """
  def generate_map(data) do
    {_, map} =
      Enum.reduce(data, {0, %{}}, fn row, {row_num, map} ->
        {_, row_data} =
          Enum.reduce(row, {0, %{}}, fn point, {col_num, minimap} ->
            {col_num + 1, Map.put(minimap, {row_num, col_num}, point)}
          end)

        map_data = Map.merge(map, row_data)
        {row_num + 1, map_data}
      end)

    map
  end

  def part2(args) do
    map =
      parse(args)
      |> generate_map()

    find_low_points(map)
    |> Enum.reduce([], fn {point, _val} = low_point, basins ->
      case Enum.any?(basins, fn basin ->
             Map.has_key?(basin, point)
           end) do
        true ->
          basins

        false ->
          found = get_basin(low_point, map, %{})
          [found | basins]
      end
    end)
    |> Enum.reduce([], fn basin, previous_basins ->
      # if two low points share a basin, they need to be merged together
      case Enum.filter(previous_basins, fn pb ->
             MapSet.intersection(MapSet.new(basin), MapSet.new(pb)) |> MapSet.size() > 0
           end) do
        [] ->
          [basin | previous_basins]

        buddies ->
          no_buddies = previous_basins -- buddies

          combined =
            Enum.reduce(buddies, basin, fn buddy, big_basin ->
              Map.merge(big_basin, buddy)
            end)

          [combined | no_buddies]
      end
    end)
    |> Enum.map(&Enum.count(&1))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  @doc """
      iex> map = %{{4, 5} => 6,{1, 2} => 8,{0, 9} => 0,{3, 6} => 6,{2, 4} => 7,{4, 8} => 7,{0, 3} => 9,{1, 1} => 9,{4, 3} => 9,{3, 7} => 7,{0, 5} => 4,{0, 1} => 1,{4, 0} => 9,{3, 2} => 6,{0, 8} => 1,{3, 1} => 7,{2, 0} => 9,{2, 7} => 8,{4, 6} => 5,{0, 7} => 2,{0, 0} => 2,{2, 8} => 9,{1, 4} => 8,{0, 4} => 9,{1, 7} => 9,{4, 2} => 9,{2, 3} => 6,{1, 8} => 2,{3, 4} => 8,{2, 1} => 8,{4, 7} => 6,{3, 3} => 7,{3, 0} => 8,{4, 9} => 8,{1, 6} => 4,{4, 1} => 8,{1, 9} => 1,{3, 5} => 9,{1, 0} => 3,{2, 6} => 9,{1, 5} => 9,{2, 5} => 8,{2, 2} => 5,{0, 2} => 9,{4, 4} => 9,{0, 6} => 3,{3, 8} => 8,{1, 3} => 7}
      iex> AdventOfCode.Day09.get_basin({{2,2}, 5}, map, %{})
      %{{2,2} => 5, {1,2} => 8, {1,3} => 7, {1,4} => 8, {2,1} => 8, {2,3} => 6, {2,4} => 7, {2,5} => 8, {3,0} => 8, {3,1} => 7, {3,2} =>6, {3,3} => 7, {3,4} => 8, {4,1} => 8}
  """
  # ridge
  def get_basin({_, 9}, _, acc), do: acc

  def get_basin({{row, col} = k, v}, map, acc) when is_map_key(map, k) do
    updated = Map.put(acc, k, v)

    [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
    |> Enum.reduce(%{}, fn point, inside_acc ->
      case Map.get(map, point, nil) do
        nil ->
          inside_acc

        value when value >= v ->
          get_basin({point, value}, Map.delete(map, k), updated)
          |> Map.merge(inside_acc)

        _ ->
          inside_acc
      end
    end)
    |> Map.merge(updated)
  end

  # edge of the board or already counted
  def get_basin(_, _, acc), do: acc

  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn line ->
      String.graphemes(line)
      |> Enum.map(fn char ->
        String.to_integer(char)
      end)
    end)
  end
end
