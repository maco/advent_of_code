defmodule AdventOfCode.Day12 do
  ## Thanks to Guy Argo (whose solution proved I didn't need to learn about
  ## libgraph because a normal depth-first-search would do) and Mathijs Saey
  ## (who helped me understand what the heck Guy's code was doing with MapSets)

  def part1(args) do
    edges = String.split(args, "\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "-")
    end)

    graph = Enum.reduce(edges, %{}, fn [from, to], paths ->
      to_set = Map.get(paths, to, MapSet.new()) |> MapSet.put(from)
      with_to = Map.put(paths, to, to_set)
      from_set = Map.get(with_to, from, MapSet.new()) |> MapSet.put(to)
      Map.put(with_to, from, from_set)
    end)

    walk(graph, ["start"], &available_rooms/2)
    |> List.flatten()
    |> Enum.filter(&(&1 == "end"))
    |> Enum.count()
  end


  def walk(graph, [current_room | _previous_rooms] = history, find_available) do
    find_available.(history, Map.get(graph, current_room))
    |> Enum.map(fn
      "end" -> Enum.reverse(["end" | history])
      next -> walk(graph, [next | history], find_available)
    end)
  end

  @doc """
      iex> AdventOfCode.Day12.available_rooms(["A", "a"], MapSet.new(["A", "a", "b"]))
      ["A", "b"]
  """
  def available_rooms(history, rooms) do
    small_rooms = MapSet.to_list(rooms) |> Enum.filter(&(String.downcase(&1) == &1))
    Enum.reject(rooms, &(&1 in small_rooms and &1 in history))
  end

  def part2(args) do
    edges = String.split(args, "\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "-")
    end)

    graph = Enum.reduce(edges, %{}, fn [from, to], paths ->
      to_set = Map.get(paths, to, MapSet.new()) |> MapSet.put(from)
      with_to = Map.put(paths, to, to_set)
      from_set = Map.get(with_to, from, MapSet.new()) |> MapSet.put(to)
      Map.put(with_to, from, from_set)
    end)

    walk(graph, ["start"], &available_rooms2/2)
    |> List.flatten()
    |> Enum.filter(&(&1 == "end"))
    |> Enum.count()
  end

  @doc """
      iex> AdventOfCode.Day12.available_rooms2(
      ...> ["A", "b", "a", "b"],
      ...> MapSet.new(["A", "a", "b", "c"]))
      ["A", "c"]

      iex> AdventOfCode.Day12.available_rooms2(
      ...> ["A", "b", "A", "b"],
      ...> MapSet.new(["A", "a", "b", "c"]))
      ["A", "a", "c"]

      iex> AdventOfCode.Day12.available_rooms2(
      ...> ["A", "b", "A", "b"],
      ...> MapSet.new(["A", "a", "b", "c", "end"]))
      ["A", "a", "c", "end"]
  """
  def available_rooms2(history, rooms) do
    small_rooms = MapSet.to_list(rooms)
    |> Enum.filter(&(String.downcase(&1) == &1))

    visited_twice = Enum.frequencies(history)
    |> Enum.filter(fn {k, v} -> String.downcase(k) == k and v == 2 end)
    |> Enum.map(&elem(&1,0))

    Enum.reject(rooms, fn room ->
      cond do
        length(visited_twice) > 0 and room in small_rooms and room in history -> true
        room == "start" and room in history -> true
        room == "end" and room in history -> true
        true -> false
      end
    end)
  end
end
