defmodule AdventOfCode.Day01b do
@moduledoc """
  But I also wanted to try it out with Enum.chunk_every/4
"""
  def part1(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(& String.to_integer/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end

  def part2(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(& String.to_integer/1)
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.count(fn [a, _b, _c, d] -> a < d end)
  end
end
