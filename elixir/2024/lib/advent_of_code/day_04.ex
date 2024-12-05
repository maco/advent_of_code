defmodule AdventOfCode.Day04 do
  import AdventOfCode.Parsing

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
    x_locations = Map.filter(grid, fn {_key, val} -> val == "X" end)

    Enum.reduce(x_locations, 0, fn {x_pos, _}, total ->
      xmases2 =
        Enum.count(operations, fn operation ->
          find_neighbors(grid, x_pos, operation)
          |> is_xmas?
        end)

      total + xmases2
    end)
  end

  def part2(_args) do
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
