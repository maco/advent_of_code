defmodule AdventOfCode.Parsing do
  def parse_columns_ints(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(
      [],
      fn
        line, [] ->
          # first time through, set up acc
          String.split(line)
          |> Enum.map(fn val -> [String.to_integer(val)] end)

        line, accs ->
          values = String.split(line)

          Enum.zip_with(values, accs, fn val, acc ->
            [String.to_integer(val) | acc]
          end)
      end
    )
    |> Enum.map(fn list -> Enum.reverse(list) end)
  end
end
