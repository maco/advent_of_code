defmodule AdventOfCode.Day03 do
  def part1(args) do
    parsed = parse(args)
    entries = Enum.count(parsed)
    gamma_list =
      parsed
      |> Enum.zip()
      |> Enum.map(fn t ->
         ones =
         Tuple.to_list(t)
          |> Enum.count(& &1 == "1")
          if ones > (entries/2) do
            "1"
          else
            "0"
          end
      end)


    gamma = gamma_list
    |> Enum.join()
    |> String.to_integer(2)

    epsilon = String.pad_leading("", Enum.count(gamma_list), "1")
    |> String.to_integer(2)
    |> Bitwise.bxor(gamma)

    gamma * epsilon

  end

  def part2(args) do
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end
end
