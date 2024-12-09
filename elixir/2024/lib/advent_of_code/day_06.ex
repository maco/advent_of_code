defmodule AdventOfCode.Day06 do
  alias AdventOfCode.Grid

  def part1(input) do
    grid = Grid.parse_grid(input)
    start = find_start(grid)
    vector = {-1, 0}
    seen = go(grid, start, vector, MapSet.new())
    Enum.count(seen)
  end

  def part2(input) do
    grid = Grid.parse_grid(input)
    start = find_start(grid)
    vector = {-1, 0}
    {_seen, loops} = get_loops(grid, start, vector, {%{}, MapSet.new()})
    IO.inspect(Enum.sort(loops))
    Enum.count(loops)
  end

  defp get_loops(grid, position, vector, {original_seen, loops}) do
    seen = Map.update(original_seen, position, [vector], fn val -> [vector | val] end)

    case Grid.peek(grid, position, vector) do
      {_, nil} ->
        # off grid, so... we're done
        # figure out what to return
        # show_loops(grid, seen)
        {seen, loops}

      {_new_pos, "#"} ->
        # already has an obstacle, so just keep going
        new_vector = Grid.turn_right(vector)
        get_loops(grid, position, new_vector, {seen, loops})

      {new_pos, _} ->
        # place an object
        # then run as normal
        # which means alter the grid we pass to the next function
        possible_grid = %{grid | new_pos => "#"}

        case (not Map.has_key?(seen, new_pos)) and has_loop?(possible_grid, position, vector, original_seen) do
          true -> get_loops(grid, new_pos, vector, {seen, MapSet.put(loops, new_pos)})
          false -> get_loops(grid, new_pos, vector, {seen, loops})
        end
    end
  end

  defp has_loop?(grid, position, vector, original_seen) do
    seen = Map.update(original_seen, position, [vector], fn val -> [vector | val] end)

    case is_loop?(position, vector, original_seen) do
      true ->
        true

      false ->
        case Grid.peek(grid, position, vector) do
          {_, nil} ->
            # off grid
            false

          {_new_pos, "#"} ->
            new_vector = Grid.turn_right(vector)
            has_loop?(grid, position, new_vector, seen)

          {new_pos, _} ->
            has_loop?(grid, new_pos, vector, seen)
        end
    end
  end

  defp is_loop?(position, vector, seen) do
    vector in Map.get(seen, position, [])
  end

  defp find_start(grid) do
    {key, _val} = Enum.find(grid, fn {_key, val} -> val == "^" end)
    key
  end

  defp go(grid, position, vector, seen) do
    seen = MapSet.put(seen, position)

    case Grid.peek(grid, position, vector) do
      {_, nil} ->
        seen

      {_new_pos, "#"} ->
        new_vector = Grid.turn_right(vector)
        go(grid, position, new_vector, seen)

      {new_pos, _} ->
        go(grid, new_pos, vector, seen)
    end
  end

  # defp show_loops(grid, seen) do
  #   keys = Map.keys(grid) |> Enum.sort()

  #   Enum.reduce(keys, [], fn
  #     {_row, 0} = k, acc ->
  #       Enum.reverse(acc) |> Enum.join("") |> IO.puts()
  #       [Map.get(seen, k, ["*"]) |> List.first() |> vec_arrow]

  #     k, acc ->
  #       [Map.get(seen, k, ["*"]) |> List.first() |> vec_arrow | acc]
  #   end)
  #   |> Enum.reverse()
  #   |> Enum.map(fn k -> Map.get(seen, k, ["*"]) |> List.first() |> vec_arrow end)
  #   |> IO.puts()

  #   grid
  # end

  def vec_arrow({-1, 0}), do: "^"
  def vec_arrow({0, 1}), do: ">"
  def vec_arrow({1, 0}), do: "v"
  def vec_arrow({0, -1}), do: "<"
  def vec_arrow(_), do: "*"
end
