defmodule AdventOfCode.Day11 do
  def part1(args) do
    grid = parse(args)
    {_, flash_total} = Enum.reduce(1..100, {grid, 0}, fn _, {g, flashes} ->
      {u, f} = do_step(g, 0)
      {u, f + flashes}
    end)
    flash_total
  end

  # @doc ~S"""
  #   iex> octopuses = %{{0, 0} => {1, false}, {0, 1} => {1, false}, {0, 2} => {1, false}, {0, 3} => {1, false},
  #   ...> {0, 4} => {1, false}, {1, 0} => {1, false}, {1, 1} => {9, false}, {1, 2} => {9, false},
  #   ...> {1, 3} => {9, false}, {1, 4} => {1, false}, {2, 0} => {1, false}, {2, 1} => {9, false},
  #   ...> {2, 2} => {1, false}, {2, 3} => {9, false}, {2, 4} => {1, false}, {3, 0} => {1, false},
  #   ...> {3, 1} => {9, false}, {3, 2} => {9, false}, {3, 3} => {9, false}, {3, 4} => {1, false},
  #   ...> {4, 0} => {1, false}, {4, 1} => {1, false}, {4, 2} => {1, false}, {4, 3} => {1, false},
  #   ...> {4, 4} => {1, false}}
  #   iex> AdventOfCode.Day11.do_step(octopuses, 0)
  #   [{1,1}, {1,2}, {1,3}, {2,1}, {2,2}, {2,3}, {3,1}, {3,2}, {3,3}]
  # """
  def do_step(grid, flashes) do
    bump_all(grid)
    |> do_flash()
    |> finalize_flash(flashes)
  end

  def bump_all(grid) do
    Enum.reduce(grid, grid, fn {k, _}, updated ->
      updated
      |> replace_with(k, fn {x, y} -> {x + 1, y} end)
    end)

  end

  def finalize_flash(grid, flashes) do
    nines = Enum.filter(grid, fn {_,{v, _}} -> v > 9 end)
    |> Map.new()
    |> Enum.reduce(%{}, fn {k, _}, updated ->
      Map.put(updated, k, {0, false})
    end)

    {Map.merge(grid, nines), flashes + Enum.count(nines)}
  end

  def do_flash(grid) do
    up = Enum.reduce(grid, grid, fn {r,c}, updated ->
      do_flash(updated, {r,c})
    end)

    if grid != up do
      do_flash(up)
    else
      up
    end
  end

  def do_flash(grid, {octopus, _}) do
    {val, flashed} = grid[octopus]
    if val <= 9 or is_nil(val) or flashed == true do
      grid
    else
      grid
      |> replace_with(octopus, fn {v, _} -> {v, true} end)
      |> boost_neighbors(octopus)
    end
  end

  def boost_neighbors(grid, {r,c}) do
    grid
    |> replace_with({r - 1, c}, fn {x, y} -> {x + 1, y} end)
    |> replace_with({r - 1, c - 1}, fn {x, y} -> {x + 1, y} end)
    |> replace_with({r - 1, c + 1}, fn {x, y} -> {x + 1, y} end)
    |> replace_with({r, c - 1}, fn {x, y} -> {x + 1, y} end)
    |> replace_with({r, c + 1}, fn {x, y} -> {x + 1, y} end)
    |> replace_with({r + 1, c}, fn {x, y} -> {x + 1, y} end)
    |> replace_with({r + 1, c - 1}, fn {x, y} -> {x + 1, y} end)
    |> replace_with({r + 1, c + 1}, fn {x, y} -> {x + 1, y} end)
  end

  def replace_with(map, key, _) when not is_map_key(map, key), do: map
  def replace_with(map, key, f) do
    Map.replace(map, key, f.(map[key]))
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
      {{row, col}, {number - ?0, false}}
    end
  end

  # this just seemed like it'd be helpful
  def show_grid(grid), do: show_grid(grid, "next")

  def show_grid(grid, label) do
    IO.puts(label)
    keys = Map.keys(grid) |> Enum.sort()
    for {_row, col} = k <- keys do
      if col == 0 do
        IO.write("\n")
      end
      {digit, _} = Map.get(grid, k, '*')
      case digit do
        0 ->
          IO.write(IO.ANSI.format([:light_cyan,"0 "]))
        10 ->
          IO.write("A ")
        11 ->
          IO.write("B ")
        12 ->
          IO.write("C ")
        13 ->
          IO.write("D ")
        14 ->
          IO.write("E ")
        15 ->
          IO.write("F ")
        16 ->
          IO.write("G ")
        _ ->
          IO.write("#{digit} ")
      end
    end
    IO.puts("\n")
    grid
  end
end
