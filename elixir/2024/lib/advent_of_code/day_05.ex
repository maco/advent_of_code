defmodule AdventOfCode.Day05 do
  def part1(input) do
    {rules, [_ | updates]} =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.split_while(fn line -> line != "" end)

    ruleset =
      Enum.reduce(rules, %{}, fn rule, acc ->
        [key, val] = String.split(rule, "|")
        Map.update(acc, key, [val], fn current -> [val | current] end)
      end)

    updates
    |> Enum.map(&String.split(&1, ","))
    |> Enum.filter(fn pages ->
      Enum.reduce_while(pages, MapSet.new(), fn page, seen ->
        related = Map.get(ruleset, page, [])

        case Enum.any?(related, fn rel -> MapSet.member?(seen, rel) end) do
          true ->
            {:halt, false}

          _ ->
            {:cont, MapSet.put(seen, page)}
        end
      end)
    end)
    |> Enum.map(fn update ->
      middle = Integer.floor_div(length(update), 2)
      {val, _rest} = List.pop_at(update, middle)
      String.to_integer(val)
    end)
    |> Enum.sum()
  end

  def part2(_args) do
  end
end
