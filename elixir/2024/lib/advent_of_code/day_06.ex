defmodule AdventOfCode.Day06 do
  import AdventOfCode.Parsing

  def part1(input) do
    grid = parse_grid(input)
    start = find_start(grid)
    vector = {-1, 0}
    seen = go(grid, start, vector, MapSet.new())
    Enum.count(seen)
  end

  def part2(_args) do
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

    for {_row, col} = k <- keys do
      if col == 0 do
        IO.write("\n")
      end

      Map.get(grid, k, "*") |> IO.write()
    end

    Enum.reduce(keys, [], fn
      {_row, 0}, acc ->
        Enum.reverse(acc) |> Enum.join("") |> IO.write()
        IO.write("\n")
        []

      k, acc ->
        [Map.get(grid, k, "*") | acc]
    end)

    IO.puts("\n")
    grid
  end
end
