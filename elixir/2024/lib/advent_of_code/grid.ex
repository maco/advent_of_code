defmodule AdventOfCode.Grid do
  def parse_grid(input) do
    # Saw José do it similarly in 2021
    lines = String.split(input, "\n", trim: true)

    for {line, row} <- Enum.with_index(lines),
        {letter, col} <- Enum.with_index(String.graphemes(line)),
        into: %{} do
      {{row, col}, letter}
    end
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

  def find_in_grid(grid, needle, fun) do
    Map.filter(grid, fn {_key, val} -> fun.(val, needle) end)
  end

  def peek(grid, pos, vector) do
    new_pos = calculate_move(pos, vector)
    val = Map.get(grid, new_pos)
    # val is nil if it's off the grid
    {new_pos, val}
  end

  defp calculate_move({row, col}, {vec_row, vec_col}), do: {row + vec_row, col + vec_col}

  def turn_right({-1, 0}), do: {0, 1}
  def turn_right({0, 1}), do: {1, 0}
  def turn_right({1, 0}), do: {0, -1}
  def turn_right({0, -1}), do: {-1, 0}

  def turn_left({0, 1}), do: {-1, 0}
  def turn_left({1, 0}), do: {0, 1}
  def turn_left({0, -1}), do: {1, 0}
  def turn_left({-1, 0}), do: {0, -1}
end
