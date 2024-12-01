defmodule AdventOfCode.Day15 do
  def part1(args) do
    nodes = parse(args)
    |> Map.delete({0,0})

    target = Map.keys(nodes) |> Enum.max()

    queue = PriorityQueue.new()
    |> PriorityQueue.put(0, {0,0})

    dijkstra(nodes, queue, target)
  end

  # def dijkstra(_unvisited, [{k, v} |_], {{r, c}, _weight}, {r, c}), do: v

  def dijkstra(unvisited, queue, target) do
    case PriorityQueue.min!(queue) do
      {total, ^target} -> total

      {total, {row, col}} ->
        smaller_queue = PriorityQueue.delete_min!(queue)

        # calculate neighbor distances and add to queue
        new_queue = get_neighbors(unvisited, {row, col})
        |> Enum.reduce(smaller_queue, fn {loc, weight}, q ->
          PriorityQueue.put(q, weight + total, loc)
        end)

        # remove current from unvisited map to prevent cycles
        shorter_unvisited = Map.delete(unvisited, {row, col})

        dijkstra(shorter_unvisited, new_queue, target)
    end
  end

  def get_neighbors(unvisited, {row, col}) do
    Map.filter(unvisited, fn {{r, c}, _} ->
      (c == col and (r == (row + 1) or r == (row - 1)))
      or
      (r == row and (c == (col + 1) or c == (col - 1)))
    end)
  end

  def part2(args) do
    initial = parse(args)

    {max_row, max_col} = Map.keys(initial) |> Enum.max()

    nodes = expand_board(initial, {max_row + 1, max_col + 1})
    |> Map.delete({0,0})

    target = Map.keys(nodes) |> Enum.max()

    queue = PriorityQueue.new()
    |> PriorityQueue.put(0, {0,0})

    dijkstra(nodes, queue, target)
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
    Map.map(board, fn {_, v} ->
      case v do
        9 -> 1
        n -> n + 1
      end
    end)
  end

  def parse(input) do
    # José did this in day 9, and it's so much tidier than reduce inside reduce.
    # I need to remember this trick.
    lines = String.split(input, "\n", trim: true)
    for {line, row} <- Enum.with_index(lines),
        {number, col} <- Enum.with_index(String.to_charlist(line)),
        into: %{} do
      {{row, col}, number - ?0}
    end
  end

  def show_grid(grid) do
    keys = Map.keys(grid) |> Enum.sort()
    for {_row, col} = k <- keys do
      if col == 0 do
        IO.write("\n")
      end
      digit = Map.get(grid, k, '*')
      IO.write(digit)
    end
    grid
  end
end
