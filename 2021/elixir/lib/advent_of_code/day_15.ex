defmodule AdventOfCode.Day15 do
  def part1(args) do
    nodes = parse(args)
    |> Map.update({0,0}, nil, fn {v, dist} -> {v, 0} end)

    target = get_target(nodes)

    dijkstra(Map.delete(nodes, {0,0}), {{0,0}, nodes[{0,0}]}, target)
  end

  def get_target(nodes) do
    {{max_r, _}, _} = Enum.max_by(nodes, fn {{r, _c}, _} -> r end)
    {{_, max_c}, _} = Enum.max_by(nodes, fn {{_r, c}, _} -> c end)

    {max_r, max_c}
  end

  def dijkstra(_unvisited, {{r, c}, {_, distance}}, {r, c}), do: distance

  def dijkstra(unvisited, {coord, {label, distance}}, target) do
    neighbors = get_neighbors(unvisited, coord)
    |> Map.map(fn {_, {v, d}} ->
      {v, min(distance + v, d)}
    end)

    updated_unvisited = update_distances(unvisited, neighbors)

    next = Enum.min_by(updated_unvisited, fn {_, {_, d}}
      -> d
    end)

    dijkstra(Map.delete(updated_unvisited, coord), next, target)
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

  def expand_board(board, {max_row, max_col}) do
    row1 = make_row(board, {max_row, max_col})
    Enum.reduce(1..4, {row1, row1}, fn boards_down, {last_row, expanded} ->
      next_row = bump_risk(last_row)
      more_row = Enum.reduce(next_row, %{}, fn {{r, c}, v}, acc ->
        Map.put(acc, {r + (boards_down * max_row), c}, v)
      end)
      |> Map.merge(expanded)
      {next_row, more_row}
    end)
    |> elem(1)
  end

  def make_row(board, {_max_row, max_col}) do
    Enum.reduce(1..4, {board, board}, fn boards_across, {last_board, expanded} ->
      next_board = bump_risk(last_board)
      more_row = Enum.reduce(next_board, %{}, fn {{r, c}, v}, acc ->
        Map.put(acc, {r, c + (boards_across * max_col)}, v)
      end)
      |> Map.merge(expanded)
      {next_board, more_row}
    end)
    |> elem(1)
  end

  def bump_risk(board) do
    Map.map(board, fn {_, {v, d}} ->
      new_v = case v do
        9 -> 1
        n -> n + 1
      end
      {new_v, d}
    end)
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

  def show_grid(grid) do
    keys = Map.keys(grid) |> Enum.sort()
    for {_row, col} = k <- keys do
      if col == 0 do
        IO.write("\n")
      end
      {digit, _} = Map.get(grid, k, '*')
      IO.write(digit)
    end
    grid
  end
end
