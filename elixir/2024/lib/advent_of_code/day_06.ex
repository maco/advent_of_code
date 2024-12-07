defmodule AdventOfCode.Day06 do
  import AdventOfCode.Parsing

  def part1(input) do
    grid = parse_grid(input)
    start = find_start(grid)
    vector = {-1, 0}
    seen = go(grid, start, vector, MapSet.new())
    Enum.count(seen)
  end

  def part2(input) do
    grid = parse_grid(input)
    start = find_start(grid)
    vector = {-1, 0}
    {_seen, loops} = get_loops(grid, start, vector, {%{}, 0})
    loops
  end

  defp get_loops(grid, position, vector, {original_seen, loops}) do
    seen = Map.update(original_seen, position, [vector], fn val -> [vector | val] end)

    case look(grid, position, vector) do
      {_, nil} ->
        # off grid, so... we're done
        # figure out what to return
        {seen, loops}

      {_new_pos, "#"} ->
        # already has an obstacle, so just keep going
        new_vector = turn(vector)
        get_loops(grid, position, new_vector, {seen, loops})

      {new_pos, _} ->
        # place an object
        # then run as normal
        # which means alter the grid we pass to the next function
        possible_grid = %{grid | new_pos => "#"}

        case has_loop?(possible_grid, position, vector, original_seen) do
          true -> get_loops(grid, new_pos, vector, {seen, loops + 1})
          false -> get_loops(grid, new_pos, vector, {seen, loops})
        end
    end
  end

  defp has_loop?(grid, position, vector, seen) do
    case is_loop?(position, vector, seen) do
      true ->
        true

      false ->
        case look(grid, position, vector) do
          {_, nil} ->
            # off grid
            false

          {_new_pos, "#"} ->
            new_vector = turn(vector)
            has_loop?(grid, position, new_vector, seen)

          {new_pos, _} ->
            has_loop?(grid, new_pos, vector, seen)
        end
    end
  end

  defp is_loop?(position, vector, seen) do
    vector in Map.get(seen, position, [])
  end

  defp go(grid, position, vector, seen) do
    seen = MapSet.put(seen, position)

    case look(grid, position, vector) do
      {_, nil} ->
        seen

      {_new_pos, "#"} ->
        new_vector = turn(vector)
        go(grid, position, new_vector, seen)

      {new_pos, _} ->
        go(grid, new_pos, vector, seen)
    end
  end

  defp turn({-1, 0}), do: {0, 1}
  defp turn({0, 1}), do: {1, 0}
  defp turn({1, 0}), do: {0, -1}
  defp turn({0, -1}), do: {-1, 0}

  defp look(grid, pos, vector) do
    new_pos = calculate_move(pos, vector)
    val = Map.get(grid, new_pos)
    # val is nil if it's off the grid
    {new_pos, val}
  end

  defp calculate_move({row, col}, {row_dir, col_dir}), do: {row + row_dir, col + col_dir}

  defp find_start(grid) do
    {key, _val} = Enum.find(grid, fn {_key, val} -> val == "^" end)
    key
  end

  def show_grid(grid, label) do
    IO.puts(label)
    keys = Map.keys(grid) |> Enum.sort()

    Enum.reduce(keys, [], fn
      {_row, 0} = k, acc ->
        Enum.reverse(acc) |> Enum.join("") |> IO.puts()
        [Map.get(grid, k, "*")]

      k, acc ->
        [Map.get(grid, k, "*") | acc]
    end)
    |> Enum.reverse()
    |> IO.puts()

    grid
  end
end
