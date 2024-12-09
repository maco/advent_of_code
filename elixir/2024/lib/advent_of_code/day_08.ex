defmodule AdventOfCode.Day08 do
  import AdventOfCode.Grid

  def part1(input) do
    grid = parse_grid(input)

    antennae =
      grid
      |> find_in_grid(".", &Kernel.!=/2)
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

  def part2(_args) do
  end

  defp get_antinodes({_key, pairs}) do
    Enum.reduce(pairs, [], fn {loc1, loc2}, acc ->
      vector = get_vector(loc1, loc2)
      [add_vector(loc2, vector), subtract_vector(loc1, vector) | acc]
    end)
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
