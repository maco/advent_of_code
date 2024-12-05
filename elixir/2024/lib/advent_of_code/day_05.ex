defmodule AdventOfCode.Day05 do
  def part1(input) do
    {ruleset, updates} = parse_input(input)
    {good, _bad} = good_bad_updates(updates, ruleset)
    sum_centers(good)
  end

  def part2(input) do
    {ruleset, updates} = parse_input(input)
    {_good, bad} = good_bad_updates(updates, ruleset)

    Enum.map(bad, &reorder_pages(&1, ruleset))
    |> sum_centers
  end

  defp parse_input(input) do
    {rules, [_ | updates]} =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.split_while(fn line -> line != "" end)

    ruleset =
      Enum.reduce(rules, %{}, fn rule, acc ->
        [key, val] = String.split(rule, "|") |> Enum.map(&String.to_integer/1)
        Map.update(acc, key, [val], fn current -> [val | current] end)
      end)

    updates =
      updates
      |> Enum.map(fn update -> String.split(update, ",") |> Enum.map(&String.to_integer/1) end)

    {ruleset, updates}
  end

  defp good_bad_updates(updates, ruleset) do
    Enum.split_with(updates, fn pages ->
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
  end

  defp sum_centers(updates) do
    Enum.map(updates, fn update ->
      middle = Integer.floor_div(length(update), 2)
      {val, _rest} = List.pop_at(update, middle)
      val
    end)
    |> Enum.sum()
  end

  defp reorder_pages(pages, ruleset) do
    Enum.reduce(pages, [], fn
      page, [] ->
        [page]

      page, acc ->
        case find_last(acc, fn x -> x in Map.get(ruleset, page, []) end) do
          nil ->
            [page | acc]

          index ->
            List.insert_at(acc, index - 1, page)
        end
    end)
  end

  defp find_last(iter, fun) do
    index =
      iter
      |> Enum.reverse()
      |> Enum.find_index(fun)

    case index do
      nil -> nil
      x -> x * -1
    end
  end
end
