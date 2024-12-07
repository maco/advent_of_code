defmodule AdventOfCode.Day07 do
  def part1(input) do
    data = parse(input)

    Enum.filter(data, fn [test, nums] ->
      possible = possible_results(Enum.reverse(nums), [&Kernel.+/2, &Kernel.*/2])
      test in possible
    end)
    |> Enum.reduce(0, fn [test, _], acc -> acc + test end)
  end

  def part2(input) do
    data = parse(input)

    Enum.filter(data, fn [test, nums] ->
      possible = possible_results(Enum.reverse(nums), [&Kernel.+/2, &Kernel.*/2, &concatenate/2])
      test in possible
    end)
    |> Enum.reduce(0, fn [test, _], acc -> acc + test end)
  end

  defp concatenate(x, y) do
    Enum.join(Integer.digits(y) ++ Integer.digits(x)) |> String.to_integer()
  end

  defp possible_results([x], _), do: [x]

  defp possible_results([head | tail], operators) do
    subresults = possible_results(tail, operators)

    Enum.flat_map(subresults, fn sub ->
      Enum.map(operators, fn op -> op.(head, sub) end)
    end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [test, nums] = String.split(line, ":", trim: true)
      nums = String.split(nums) |> Enum.map(&String.to_integer/1)
      [String.to_integer(test), nums]
    end)
  end
end
