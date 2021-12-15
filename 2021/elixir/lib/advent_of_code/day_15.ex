defmodule AdventOfCode.Day15 do
  def part1(args) do
    nodes = parse(args)
    |> Map.update({0,0}, nil, fn {v, dist} -> {v, 0} end)

    {{max_r, _}, _} = Enum.max_by(nodes, fn {{r, _c}, _} -> r end)
    {{_, max_c}, _} = Enum.max_by(nodes, fn {{_r, c}, _} -> c end)

    target = {max_r, max_c}

    dijkstra(Map.delete(nodes, {0,0}), nodes, {{0,0}, nodes[{0,0}]}, target)
  end

  def dijkstra(_unvisited, _nodes, {{r, c}, {_, distance}}, {r, c}), do: distance

  def dijkstra(unvisited, nodes, {coord, {label, distance}}, target) do
    neighbors = get_neighbors(unvisited, coord)
    |> Map.map(fn {_, {v, d}} ->
      {v, min(distance + v, d)}
    end)

    updated_nodes = update_distances(nodes, neighbors)
    updated_unvisited = update_distances(unvisited, neighbors)

    next = Enum.min_by(updated_unvisited, fn {_, {_, d}}
      -> d
    end)

    dijkstra(Map.delete(updated_unvisited, coord), updated_nodes, next, target)
  end

  def update_distances(map, neighbors) do
    Map.merge(map, neighbors, fn _k, {val, d1}, {_, d2} ->
      {val, min(d1, d2)}
    end)
  end

  def get_neighbors(unvisited, {row, col}) do
    Map.filter(unvisited, fn {{r, c}, _} ->
      (c == col and (r == (row + 1) or r == (row - 1)))
      or
      (r == row and (c == (col + 1) or c == (col - 1)))
    end)
  end

  def part2(args) do
  end

  def parse(input) do
    # José did this in day 9, and it's so much tidier than reduce inside reduce.
    # I need to remember this trick.
    lines = String.split(input, "\n", trim: true)
    for {line, row} <- Enum.with_index(lines),
        {number, col} <- Enum.with_index(String.to_charlist(line)),
        into: %{} do
      {{row, col}, {number - ?0, :infinity}}
    end
  end
end
