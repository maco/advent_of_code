defmodule AdventOfCode.Day04 do
  import AdventOfCode.Grid

  def part1(input) do
    operations = [
      {&Kernel.+/2, &Kernel.+/2},
      {&Kernel.-/2, &Kernel.-/2},
      {&Kernel.+/2, &Kernel.-/2},
      {&Kernel.-/2, &Kernel.+/2},
      {&nop/2, &Kernel.+/2},
      {&nop/2, &Kernel.-/2},
      {&Kernel.+/2, &nop/2},
      {&Kernel.-/2, &nop/2}
    ]

    grid = parse_grid(input)
    x_locations = find_in_grid(grid, "X", &Kernel.==/2)

    Enum.reduce(x_locations, 0, fn {x_pos, _}, total ->
      xmases2 =
        Enum.count(operations, fn operation ->
          find_neighbors(grid, x_pos, operation)
          |> is_xmas?
        end)

      total + xmases2
    end)
  end

  def part2(input) do
    grid = parse_grid(input)
    a_locations = find_in_grid(grid, "A", &Kernel.==/2)

    Enum.count(a_locations, fn {key, _val} -> front_slash(grid, key) and back_slash(grid, key) end)
  end

  defp front_slash(_grid, {row, col}) when row == 0 or col == 0, do: false

  defp front_slash(grid, {row, col}) do
    letters = {Map.get(grid, {row - 1, col + 1}, nil), Map.get(grid, {row + 1, col - 1}, nil)}
    letters == {"M", "S"} or letters == {"S", "M"}
  end

  defp back_slash(grid, {row, col}) do
    letters = {Map.get(grid, {row - 1, col - 1}, nil), Map.get(grid, {row + 1, col + 1}, nil)}
    letters == {"M", "S"} or letters == {"S", "M"}
  end

  defp is_xmas?({"M", "A", "S"}), do: true
  defp is_xmas?(_), do: false

  def nop(val, _), do: val

  def find_neighbors(grid, {x_row, x_col}, {op1, op2}) do
    Enum.map(1..3, fn offset ->
      Map.get(grid, {op1.(x_row, offset), op2.(x_col, offset)}, :not_found)
    end)
    |> List.to_tuple()
  end
end
