defmodule AdventOfCode.Day04 do
  import AdventOfCode.Parsing

  @directions [:north, :south, :east, :west, :northeast, :southeast, :northwest, :southwest]

  def part1(input) do
    grid = parse_grid(input)
    x_locations = Map.filter(grid, fn {_key, val} -> val == "X" end)

    Enum.reduce(x_locations, 0, fn {x_pos, _}, total ->
      xmases =
        Enum.count(@directions, fn direction ->
          find_neighbors(grid, x_pos, direction)
          |> is_xmas?
        end)

      total + xmases
    end)
    |> IO.inspect()
  end

  def part2(_args) do
  end

  defp is_xmas?({"M", "A", "S"}), do: true
  defp is_xmas?(_), do: false

  def find_neighbors(grid, {x_row, x_col}, :east) do
    {
      Map.get(grid, {x_row, x_col + 1}, :not_found),
      Map.get(grid, {x_row, x_col + 2}, :not_found),
      Map.get(grid, {x_row, x_col + 3}, :not_found)
    }
  end

  def find_neighbors(grid, {x_row, x_col}, :west) do
    {
      Map.get(grid, {x_row, x_col - 1}, :not_found),
      Map.get(grid, {x_row, x_col - 2}, :not_found),
      Map.get(grid, {x_row, x_col - 3}, :not_found)
    }
  end

  def find_neighbors(grid, {x_row, x_col}, :south) do
    {
      Map.get(grid, {x_row + 1, x_col}, :not_found),
      Map.get(grid, {x_row + 2, x_col}, :not_found),
      Map.get(grid, {x_row + 3, x_col}, :not_found)
    }
  end

  def find_neighbors(grid, {x_row, x_col}, :north) do
    {
      Map.get(grid, {x_row - 1, x_col}, :not_found),
      Map.get(grid, {x_row - 2, x_col}, :not_found),
      Map.get(grid, {x_row - 3, x_col}, :not_found)
    }
  end

  def find_neighbors(grid, {x_row, x_col}, :southeast) do
    {
      Map.get(grid, {x_row + 1, x_col + 1}, :not_found),
      Map.get(grid, {x_row + 2, x_col + 2}, :not_found),
      Map.get(grid, {x_row + 3, x_col + 3}, :not_found)
    }
  end

  def find_neighbors(grid, {x_row, x_col}, :southwest) do
    {
      Map.get(grid, {x_row + 1, x_col - 1}, :not_found),
      Map.get(grid, {x_row + 2, x_col - 2}, :not_found),
      Map.get(grid, {x_row + 3, x_col - 3}, :not_found)
    }
  end

  def find_neighbors(grid, {x_row, x_col}, :northwest) do
    {
      Map.get(grid, {x_row - 1, x_col - 1}, :not_found),
      Map.get(grid, {x_row - 2, x_col - 2}, :not_found),
      Map.get(grid, {x_row - 3, x_col - 3}, :not_found)
    }
  end

  def find_neighbors(grid, {x_row, x_col}, :northeast) do
    {
      Map.get(grid, {x_row - 1, x_col + 1}, :not_found),
      Map.get(grid, {x_row - 2, x_col + 2}, :not_found),
      Map.get(grid, {x_row - 3, x_col + 3}, :not_found)
    }
  end
end
