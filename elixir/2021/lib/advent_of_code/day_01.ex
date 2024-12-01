defmodule AdventOfCode.Day01 do
@moduledoc """
  First, I wanted to solve it recursively.
"""

  def part1(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(& String.to_integer/1)
    |> compare1(0)
  end

  defp compare1([_head | []], total), do: total

  defp compare1([head | tail], total) do
    if hd(tail) > head do
      compare1(tail, total + 1)
    else
      compare1(tail, total)
    end
  end

  def part2(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(& String.to_integer/1)
    |> compare2(0)
  end

  defp compare2([_head | tail], total) when length(tail) < 3, do: total

  defp compare2([_head | tail] = list, total) do
    window1 = Enum.slice(list, 0..2) |> Enum.sum()
    window2 = Enum.slice(list, 1..3) |> Enum.sum()
    
    if window2 > window1 do
      compare2(tail, total + 1)
    else
      compare2(tail, total)
    end
  end
end
