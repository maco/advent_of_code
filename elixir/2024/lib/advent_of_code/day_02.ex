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
      safe_ish_changing(:inc, row, []) or safe_ish_changing(:dec, row, [])
    end)
  end

  ### safe_changing
  # Recursive through values in the row.
  # Return false if we hit an error condition.
  defp safe_changing(_, [_]), do: true
  defp safe_changing(_, [a, b | _tail]) when abs(b - a) > 3, do: false
  defp safe_changing(:inc, [a, b | _tail]) when a >= b, do: false
  defp safe_changing(:dec, [a, b | _tail]) when a <= b, do: false
  defp safe_changing(direction, [_a, b | tail]), do: safe_changing(direction, [b | tail])

  ### safe_ish_changing
  # Recurse through values in the row.
  # If we hit an error condition, try to continue in "strict mode"
  # (the functions above) with removing either of the two incompatible values.
  # The right side of the `or` only executes if the left side returns false,
  # and the choosing the "wrong" side of the two incompatible values should
  # fail on the next step forward.
  defp safe_ish_changing(_, [_], _), do: true

  defp safe_ish_changing(:inc, [a, b | tail], popped) when a < b and b - a <= 3,
    do: safe_ish_changing(:inc, [b | tail], [a | popped])

  defp safe_ish_changing(:dec, [a, b | tail], popped) when a > b and a - b <= 3,
    do: safe_ish_changing(:dec, [b | tail], [a | popped])

  # error on first pair, remove element & go to strict mode
  defp safe_ish_changing(direction, [a, b | tail], []) when a == b do
    safe_changing(direction, [a | tail])
  end

  defp safe_ish_changing(direction, [a, b | tail], []) do
    safe_changing(direction, [a | tail]) or safe_changing(direction, [b | tail])
  end

  # error elsewhere, remove element & go to strict mode
  defp safe_ish_changing(direction, [a, b | tail], [last | _]) when a == b do
    safe_changing(direction, [last, a | tail])
  end

  defp safe_ish_changing(direction, [a, b | tail], [last | _]) do
    safe_changing(direction, [last, a | tail]) or safe_changing(direction, [last, b | tail])
  end
end
