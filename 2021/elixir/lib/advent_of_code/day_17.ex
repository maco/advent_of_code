defmodule AdventOfCode.Day17 do
  def part1(args) do
    %{x1: x1, x2: x2, y1: y1, y2: y2} = parse(args)
    target = {x1..x2, y1..y2}

    {x, y} = range(x1, x2, y1, y2)

    {highest, _velocity} =
    Enum.reduce(x, {-1_000_000, {0,0}}, fn vx, {bestest_height, _v}->
        Enum.reduce(y, {bestest_height, {vx, 0}}, fn vy, {best_height, best_vel}->
          {final_pos, new_height} = try_velocity({0,0}, {vx, vy}, target)
          max_height = max(best_height, new_height)
          cond do
            inside_target?(final_pos, target) and new_height == max_height ->
              {new_height, {vx, vy}}
            true ->
              {best_height, best_vel}
          end
      end)
    end)

    highest

  end

  @spec range(number, number, number, number) :: {Range.t(), Range.t()}
  def range(x1, x2, y1, y2) do
    y = max(abs(x1), abs(x2)) * 3
    x = max(abs(y1), abs(y2)) * 3
    {-x..x, -y..y}
  end

  def try_velocity(start, velocity, target) do
    {final_pos, _, _, max_height} =
      Enum.reduce_while(1..1000, {start, velocity, target, -1_000_000},
      fn _, {position, vel, target, highest} ->
        {{_x, y} = new_pos, new_vel} = step(position, vel)
        new_highest = max(y, highest)
        case inside_target?(new_pos, target) do
          true->
              {:halt, {new_pos, new_vel, target, new_highest}}
          false ->
            {:cont, {new_pos, new_vel, target, new_highest}}
        end
      end)

      {final_pos, max_height}
  end

  @doc """
      iex> AdventOfCode.Day17.inside_target?({2,3}, {10..15, 8..12})
      false

      iex> AdventOfCode.Day17.inside_target?({10,12}, {10..15, 8..12})
      true
  """
  def inside_target?({x, y} = _position, {xs, ys} = _target) do
    x in xs and y in ys
  end

  @doc """
      iex> AdventOfCode.Day17.step({0,0}, {3,4})
      {{3,4}, {2,3}}

      iex> AdventOfCode.Day17.step({0,0}, {-3,4})
      {{-3,4}, {-2,3}}

      iex> AdventOfCode.Day17.step({0,0}, {0,4})
      {{0,4}, {0,3}}
  """
  def step({x,y} = _position, {vx, vy} = _velocity) when vx > 0 do
    {{x + vx, y + vy}, {vx - 1, vy - 1}}
  end

  def step({x,y} = _position, {vx, vy} = _velocity) when vx < 0 do
    {{x + vx, y + vy}, {vx + 1, vy - 1}}
  end

  def step({x,y} = _position, {vx, vy} = _velocity) when vx == 0 do
    {{x + vx, y + vy}, {vx, vy - 1}}
  end

  def part2(args) do
    %{x1: x1, x2: x2, y1: y1, y2: y2} = parse(args)
    target = {x1..x2, y1..y2}

    {x, y} = range(x1, x2, y1, y2)

    Enum.reduce(x, [], fn vx, vs ->
      new_vs = Enum.reduce(y, [], fn vy, velocities->
        {final_pos, _new_height} = try_velocity({0,0}, {vx, vy}, target)
        case inside_target?(final_pos, target) do
          true ->
            [{vx, vy} | velocities] 
          false ->
            velocities
        end
      end)
      [new_vs | vs]
    end)
    |> List.flatten
    |> Enum.count
  end

  def parse(input) do
    Regex.named_captures(~r/.*x=(?<x1>[0-9\-]*)\.\.(?<x2>[0-9\-]*), y=(?<y1>[0-9\-\.]*)\.\.(?<y2>[0-9\-\.]*)/, input)
    |> Enum.map(fn {k,v} -> {String.to_atom(k), String.to_integer(v)} end)
    |> Map.new()
  end
end
