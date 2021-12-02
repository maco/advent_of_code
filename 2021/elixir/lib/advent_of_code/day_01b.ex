defmodule AdventOfCode.Day01b do
@moduledoc """
  But I also wanted to try it out with Enum.chunk_every/4

  ...and then Akash on Elixir Slack asked about
  handling generic windows, and I made this DRYer
"""
  def part1(args) do
    compare_window(args, 2)
  end

  def part2(args) do
    compare_window(args, 4)
  end

  defp compare_window(input, size) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(& String.to_integer/1)
    |> Enum.chunk_every(size, 1, :discard)
    |> Enum.count(fn list ->
      List.first(list) < List.last(list)
    end)
  end
end
