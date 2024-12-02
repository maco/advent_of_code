defmodule AdventOfCode.Day02 do
  import AdventOfCode.Parsing

  def part1(input) do
    input
    |> parse_rows_ints
    |> Enum.count(fn row -> safe_changing(:inc, row) or safe_changing(:dec, row) end)
  end

  def part2(input) do
    parse_rows_ints(input)
    |> Enum.count(fn row ->
      safe_ish_increasing(row, []) or safe_ish_decreasing(row, [])
    end)
  end

  defp safe_changing(_, [_]), do: true
  defp safe_changing(:inc, [a, b | _tail]) when a >= b, do: false
  defp safe_changing(:dec, [a, b | _tail]) when a <= b, do: false
  defp safe_changing(_, [a, b | _tail]) when abs(b - a) > 3, do: false
  defp safe_changing(direction, [_a, b | tail]), do: safe_changing(direction, [b | tail])

  defp safe_ish_increasing([_], _), do: true

  defp safe_ish_increasing([a, b | tail], popped) when a < b and b - a <= 3,
    do: safe_ish_increasing([b | tail], [a | popped])

  defp safe_ish_increasing([a, b | tail] = _list, []) do
    safe_changing(:inc, [a | tail]) or safe_changing(:inc, [b | tail])
  end

  defp safe_ish_increasing([a, b | tail] = _list, [last | _]) do
    safe_changing(:inc, [last, a | tail]) or safe_changing(:inc, [last, b | tail])
  end

  defp safe_ish_decreasing([_], _), do: true

  defp safe_ish_decreasing([a, b | tail], popped) when a > b and a - b <= 3,
    do: safe_ish_decreasing([b | tail], [a | popped])

  defp safe_ish_decreasing([a, b | tail], []) do
    safe_changing(:dec, [a | tail]) or safe_changing(:dec, [b | tail])
  end

  defp safe_ish_decreasing([a, b | tail], [last | _]) do
    safe_changing(:dec, [last, a | tail]) or safe_changing(:dec, [last, b | tail])
  end
end
