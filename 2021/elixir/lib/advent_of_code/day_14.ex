defmodule AdventOfCode.Day14 do
  def part1(args) do
    [start, pairs] = String.split(args, "\n\n", trim: true)
    key = String.split(pairs, "\n", trim: true)
    |> Enum.reduce(%{}, fn line, map ->
      [left, right] = String.split(line, " -> ")
      left = String.graphemes(left) |> List.to_tuple()
      Map.put(map, left, right)
    end)

    start = String.graphemes(start)

    {{_, min}, {_, max}} = Enum.reduce(1..10, start, fn _, current ->
      Enum.chunk_every(current, 2, 1, :discard)
      |> Enum.map(fn [first, last] ->
        middle = Map.fetch!(key, {first, last})
        [first, middle, last]
      end)
      |> tidy()
    end)
    |> Enum.frequencies()
    |> Enum.min_max_by(fn {letter, quant} -> quant end)

    max - min
  end

  @doc """
  Takes sets of 3 letters where the last of each duplicates the next and eliminates those duplicates
      iex> AdventOfCode.Day14.tidy([["A", "B", "C"], ["C", "D", "E"], ["E", "F", "G"]])
      ["A", "B", "C", "D", "E", "F", "G"]
  """
  def tidy(list), do: do_tidy(list) |> List.flatten()
  def do_tidy([h|[]]), do: h

  def do_tidy([[first, middle, _last] = _h | t]) do
    [[first, middle] | do_tidy(t) ]
  end

  def part2(args) do
  end
end
