defmodule AdventOfCode.Day08 do
  alias AdventOfCode.Grid

  def part1(input) do
    grid = Grid.parse_grid(input)

    antennae =
      grid
      |> Grid.find_in_grid(".", &Kernel.!=/2)
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
      |> Map.reject(&(length(elem(&1, 1)) < 2))

    antinodes =
      antennae
      |> Map.new(&antennae_pairs/1)
      |> Enum.flat_map(&get_antinodes/1)

    Enum.filter(antinodes, &on_board?(grid, &1))
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(input) do
    grid = Grid.parse_grid(input)

    antennae =
      grid
      |> Grid.find_in_grid(".", &Kernel.!=/2)
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
      |> Map.reject(&(length(elem(&1, 1)) < 2))

    antennae
    |> Map.new(&antennae_pairs/1)
    |> Enum.flat_map(&get_more_antinodes(&1, grid))
    |> Enum.uniq()
    |> Enum.count()
  end

  defp get_antinodes({_key, pairs}) do
    Enum.reduce(pairs, [], fn {loc1, loc2}, acc ->
      vector = get_vector(loc1, loc2)
      [add_vector(loc2, vector), subtract_vector(loc1, vector) | acc]
    end)
  end

  defp get_more_antinodes({_key, pairs}, grid) do
    size = Grid.size(grid)

    Enum.reduce(pairs, MapSet.new(), fn {loc1, loc2}, acc ->
      vector = get_vector(loc1, loc2)
      added = next_antinode(loc1, vector, &add_vector/2, MapSet.new(), size)
      subtracted = next_antinode(loc2, vector, &subtract_vector/2, MapSet.new(), size)

      MapSet.union(acc, added)
      |> MapSet.union(subtracted)
    end)
  end

  defp next_antinode(loc, vec, fun, acc, size) do
    {max_row, max_col} = size

    case fun.(loc, vec) do
      {row, col} when row < 0 or col < 0 ->
        acc

      {row, col} when row > max_row or col > max_col ->
        acc

      new_loc ->
        next_antinode(new_loc, vec, fun, MapSet.put(acc, new_loc), size)
    end
  end

  defp get_vector({row1, col1}, {row2, col2}) do
    {row2 - row1, col2 - col1}
  end

  defp add_vector({row1, col1}, {row2, col2}) do
    {row1 + row2, col1 + col2}
  end

  defp subtract_vector({row1, col1}, {row2, col2}) do
    {row1 - row2, col1 - col2}
  end

  defp on_board?(grid, loc), do: Map.has_key?(grid, loc)

  def antennae_pairs({key, locs}) do
    pairs = do_antennae_pairs(locs, [])
    {key, pairs}
  end

  defp do_antennae_pairs([_], acc), do: acc

  defp do_antennae_pairs([head | tail], acc) do
    head_pairs = Enum.map(tail, fn x -> {head, x} end)
    head_pairs ++ do_antennae_pairs(tail, acc)
  end
end
