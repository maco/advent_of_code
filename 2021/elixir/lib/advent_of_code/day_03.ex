defmodule AdventOfCode.Day03 do
  def part1(args) do
    parsed = parse(args)
    entries = Enum.count(parsed)
    gamma_list =
      parsed
      |> Enum.zip()
      |> Enum.map(& Tuple.to_list/1)
      |> Enum.map(& find_most_common(&1, entries))

    gamma = gamma_list
    |> Enum.join()
    |> String.to_integer(2)

    epsilon = String.pad_leading("", Enum.count(gamma_list), "1")
    |> String.to_integer(2)
    |> Bitwise.bxor(gamma)

    gamma * epsilon
  end

  defp find_most_common(list, entries) do
    ones =
      list
      |> Enum.count(& &1 == "1")
      if ones > (entries/2) do
        "1"
      else
        "0"
      end
  end

  def part2(args) do
    parsed = parse(args)
    ox = filter_down(parsed, [], :max) |> rev_to_int()
    co2 = filter_down(parsed, [], :min) |> rev_to_int()
    ox * co2
  end

  defp rev_to_int(list) do
    list |> Enum.reverse() |> Enum.join() |> String.to_integer(2)
  end

  defp filter_down([[]], acc, _max_or_min), do: acc

  defp filter_down(data, acc, max_or_min) do
    first = Enum.reduce(data, [], fn [h | _], acc ->
      [h | acc]
    end)
    |> Enum.reverse()
    |> Enum.frequencies()
    |> pick_char(max_or_min)

    filtered =
      Enum.filter(data, fn [ head | _] -> head == first end)
      |> Enum.map(fn [_h | tail] -> tail end)

    filter_down(filtered, [first | acc], max_or_min)
  end

  defp pick_char(%{"0" => zeroes, "1" => ones}, :max) when zeroes > ones, do: "0"
  defp pick_char(%{"0" => zeroes, "1" => ones}, :max) when zeroes <= ones, do: "1"
  defp pick_char(%{"0" => zeroes, "1" => ones}, :min) when zeroes > ones, do: "1"
  defp pick_char(%{"0" => zeroes, "1" => ones}, :min) when zeroes <= ones, do: "0"

  defp pick_char(%{"0"=> _}, _), do: "0"
  defp pick_char(%{"1"=> _}, _), do: "1"

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end
end
