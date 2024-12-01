defmodule AdventOfCode.Day11 do
  def part1(args) do
    grid = parse(args)
    {_, flash_total} = Enum.reduce(1..100, {grid, 0}, fn _, {g, flashes} ->
      {u, f} = do_step(g, 0)
      {u, f + flashes}
    end)
    flash_total
  end

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
    nines = Map.filter(grid, fn {_,{v, _}} -> v > 9 end)
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

  # this has an off-by-one error.
  # If I count from 0, it works for the real input.
  # If I count from 1, it works for the sample input.
  def part2(args) do
    grid = parse(args)
    Enum.reduce_while(1..1000, {grid, 1}, fn _, {g, steps} ->
      {u, _} = do_step(g, 0)
      case Enum.all?(u, fn {_, {v, _}} -> v == 0 end) do
        true ->
          {:halt, steps + 1}
        false ->
          {:cont, {u, steps + 1}}
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
