defmodule AdventOfCode.Day14 do
  def part1(args) do
    {start, key} = parse(args)

    {{_, min}, {_, max}} = process_polymer(start, key, 1..10)

    max - min
  end

  def parse(input) do
    [start, pairs] = String.split(input, "\n\n", trim: true)

    key = String.split(pairs, "\n", trim: true)
    |> Enum.reduce(%{}, fn line, map ->
      [left, right] = String.split(line, " -> ")
      left = String.graphemes(left) |> List.to_tuple()
      Map.put(map, left, right)
    end)

    start = String.graphemes(start)
    {start, key}
  end

  def process_polymer(start, key, steps) do
    Enum.reduce(steps, start, fn _, current ->
      Enum.chunk_every(current, 2, 1, :discard)
      |> Enum.map(fn [first, last] ->
        middle = Map.fetch!(key, {first, last})
        [first, middle, last]
      end)
      |> tidy()
    end)
    |> Enum.frequencies()
    |> Enum.min_max_by(fn {_letter, quant} -> quant end)
  end

  @doc """
  Takes sets of 3 letters where the last of each duplicates the next and eliminates those duplicates
      iex> AdventOfCode.Day14.tidy([["A", "B", "C"], ["C", "D", "E"], ["E", "F", "G"]])
      ["A", "B", "C", "D", "E", "F", "G"]
  """
  def tidy(list), do: do_tidy(list) |> List.flatten()
  defp do_tidy([h|[]]), do: h

  defp do_tidy([[first, middle, _last] = _h | t]) do
    [[first, middle] | do_tidy(t) ]
  end

  def part2(args) do
    {start, key} = parse(args)

    all_zeroes = Map.map(key, fn _ -> 0 end)
    counts = Enum.chunk_every(start, 2, 1, :discard)
    |> Enum.reduce(all_zeroes, fn [first, second], acc ->
      Map.update(acc, {first, second}, 1, fn v -> v + 1 end)
    end)

    {min, max} = faster_polymer(counts, key, 1..40)
    |> find_min_max()

    max - min
  end

  @doc """
  Calculates how the polymer would grow
      iex> counts = %{{"N", "N"} => 1, {"N", "C"} => 1, {"C", "B"} => 1}
      iex> key = %{{"N", "N"} => "C", {"N", "C"} => "B", {"C", "B"} => "H"}
      iex> AdventOfCode.Day14.faster_polymer(counts, key, 1..1)
      %{{"N", "N"} => 0, {"N", "C"} => 1, {"C", "N"} => 1, {"N", "B"} => 1,
      {"B","C"} => 1, {"C","H"} => 1, {"H","B"} => 1, {"C", "B"} => 0}
  """
  def faster_polymer(counts, key, steps) do
    Enum.reduce(steps, counts, fn _, current ->
      changes = calculate_changes(current, key)
      Map.merge(current, changes, fn _, v1, v2 ->
        v1 + v2
      end)
    end)
  end

  @doc """
    iex> counts = %{{"B", "B"} => 0,   {"B", "C"} => 0,   {"B", "H"} => 0,   {"B", "N"} => 0,   {"C", "B"} => 1,   {"C", "C"} => 0,   {"C", "H"} => 0,   {"C", "N"} => 0,   {"H", "B"} => 0,   {"H", "C"} => 0,   {"H", "H"} => 0,   {"H", "N"} => 0,   {"N", "B"} => 0,   {"N", "C"} => 1,   {"N", "H"} => 0,   {"N", "N"} => 1 }
    iex> key = %{{"N", "N"} => "C", {"N", "C"} => "B", {"C", "B"} => "H"}
    iex> AdventOfCode.Day14.calculate_changes(counts, key)
    %{{"N", "N"} => -1, {"N", "C"} => 0, {"C", "B"} => -1, {"C","N"} => 1,
    {"N","B"} =>1, {"B","C"} => 1, {"C","H"} => 1, {"H", "B"} => 1}

    test step 3
    iex> counts = %{{"B", "B"} => 2,   {"B", "C"} => 2,   {"B", "H"} => 1,   {"B", "N"} => 0,   {"C", "B"} => 2,   {"C", "C"} => 1,   {"C", "H"} => 0,   {"C", "N"} => 1,   {"H", "B"} => 0,   {"H", "C"} => 1,   {"H", "H"} => 0,   {"H", "N"} => 0,   {"N", "B"} => 2,   {"N", "C"} => 0,   {"N", "H"} => 0,   {"N", "N"} => 0 }
    iex> key = %{{"B", "B"} => "N",   {"B", "C"} => "B",   {"B", "H"} => "H",   {"B", "N"} => "B",   {"C", "B"} => "H",   {"C", "C"} => "N",   {"C", "H"} => "B",   {"C", "N"} => "C",   {"H", "B"} => "C",   {"H", "C"} => "B",   {"H", "H"} => "N",   {"H", "N"} => "C",   {"N", "B"} => "B",   {"N", "C"} => "B",   {"N", "H"} => "C",   {"N", "N"} => "C" }
    iex> AdventOfCode.Day14.calculate_changes(counts, key)
    %{   {"B", "B"} => 2,   {"B", "C"} => 1,   {"B", "H"} => 0,   {"B", "N"} => 2,   {"C", "B"} => -2,   {"C", "C"} => 0,   {"C", "H"} => 2,   {"C", "N"} => 1,   {"H", "B"} => 3,   {"H", "C"} => -1,   {"H", "H"} => 1,   {"N", "B"} => 2,   {"N", "C"} => 1}

  """
  def calculate_changes(counts, key) do
    Enum.reduce(counts, %{}, fn
      {{first, second} = k, v}, changes when v > 0 ->
        replacement = Map.fetch!(key, k)

        Map.update(changes, k, -v, &(&1 - v))
        |> Map.update({first, replacement}, v, &(&1 + v))
        |> Map.update({replacement, second}, v, &(&1 + v))

      _, changes ->
        changes
    end)
  end

  @doc """
  Figures out the most and least common letters and how many
      iex> counts = %{{"N", "N"} => 0, {"N", "C"} => 1, {"C", "N"} => 1, {"N", "B"} => 1,
      ...> {"B","C"} => 1, {"C","H"} => 1, {"H","B"} => 1, {"C", "B"} => 0}
      iex> AdventOfCode.Day14.find_min_max(counts)
      {1, 2}
  """
  def find_min_max(counts) do
    {{_, min}, {_, max}} = Enum.reduce(counts, %{}, fn {{first, second}, count}, total ->
      Map.update(total, first, count, &(&1 + count))
      |> Map.update(second, count, &(&1 + count))
    end)
    |> Map.map(fn {_, x} -> round(x / 2) end)
    |> Enum.min_max_by(fn {_letter, quant} -> quant  end)
    {min, max}
  end
end
