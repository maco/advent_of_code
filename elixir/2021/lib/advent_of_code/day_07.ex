defmodule AdventOfCode.Day07 do
  def part1(args) do
    positions = String.trim(args) |> String.split(",") |> Enum.map(&String.to_integer/1)
    {min, max} = Enum.min_max(positions)
    Enum.reduce_while(min..max, nil, fn pos, fuel ->
      case naive_fuel_calculation(positions, pos) do
        f when f < fuel ->
          {:cont, f}
        _ ->
          {:halt, fuel}
        end
    end)
  end


  @doc"""
      iex> pos = [16,1,2,0,4,2,7,1,2,14]
      iex> AdventOfCode.Day07.naive_fuel_calculation(pos, 1)
      41
      iex> AdventOfCode.Day07.naive_fuel_calculation(pos, 2)
      37
      iex> AdventOfCode.Day07.naive_fuel_calculation(pos, 3)
      39
      iex> AdventOfCode.Day07.naive_fuel_calculation(pos, 10)
      71
  """
  def naive_fuel_calculation(positions, location) do
    Enum.reduce(positions, 0, fn pos, fuel ->
      fuel + abs(location - pos)
    end)
  end

  def part2(args) do
    positions = String.trim(args) |> String.split(",") |> Enum.map(&String.to_integer/1)
    {min, max} = Enum.min_max(positions)
    Enum.reduce_while(min..max, nil, fn pos, fuel ->
      case fuel_calculation(positions, pos) do
        f when f < fuel ->
          {:cont, f}
        _ ->
          {:halt, fuel}
        end
    end)
  end

  @doc"""
      iex> pos = [16,1,2,0,4,2,7,1,2,14]
      iex> AdventOfCode.Day07.fuel_calculation(pos, 5)
      168
  """
  def fuel_calculation(positions, location) do
    Enum.reduce(positions, 0, fn pos, fuel ->
      fuel + Enum.sum(1..abs(location - pos))
    end)
  end
end
