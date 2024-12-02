defmodule AdventOfCode.Day02 do
  import AdventOfCode.Parsing

  def part1(input) do
    input
    |> parse_rows_ints
    |> Enum.count(fn row -> safe_increasing(row) or safe_decreasing(row) end)
  end

  def part2(input) do
    parse_rows_ints(input)
    |> Enum.count(fn row ->
      safe_ish_increasing(row, []) or safe_ish_decreasing(row, [])
    end)
  end

  defp safe_increasing([_]), do: true
  defp safe_increasing([a, b | _tail]) when a >= b, do: false
  defp safe_increasing([a, b | _tail]) when b - a > 3, do: false
  defp safe_increasing([_a, b | tail]), do: safe_increasing([b | tail])

  defp safe_decreasing([_]), do: true
  defp safe_decreasing([a, b | _tail]) when a <= b, do: false
  defp safe_decreasing([a, b | _tail]) when a - b > 3, do: false
  defp safe_decreasing([_a, b | tail]), do: safe_decreasing([b | tail])

  defp safe_ish_increasing([_], _), do: true

  defp safe_ish_increasing([a, b | tail], popped) when a < b and b - a <= 3,
    do: safe_ish_increasing([b | tail], [a | popped])

  defp safe_ish_increasing([a, b | tail] = _list, []) do
    safe_increasing([a | tail]) or safe_increasing([b | tail])
  end

  defp safe_ish_increasing([a, b | tail] = _list, [last | _]) do
    safe_increasing([last, a | tail]) or safe_increasing([last, b | tail])
  end

  defp safe_ish_decreasing([_], _), do: true

  defp safe_ish_decreasing([a, b | tail], popped) when a > b and a - b <= 3,
    do: safe_ish_decreasing([b | tail], [a | popped])

  defp safe_ish_decreasing([a, b | tail], []) do
    safe_decreasing([a | tail]) or safe_decreasing([b | tail])
  end

  defp safe_ish_decreasing([a, b | tail], [last | _]) do
    safe_decreasing([last, a | tail]) or safe_decreasing([last, b | tail])
  end
end
