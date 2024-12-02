defmodule AdventOfCode.Parsing do
  def parse_columns_ints(input) do
    input
    |> parse_rows_ints
    # transpose matrix
    |> Enum.zip_with(&Function.identity/1)
  end

  def parse_rows_ints(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn row -> row |> String.split() |> Enum.map(&String.to_integer/1) end)
  end
end
