defmodule AdventOfCode.Day17Test do
  use ExUnit.Case
  doctest AdventOfCode.Day17

  import AdventOfCode.Day17

  test "part1" do
    input = "target area: x=20..30, y=-10..-5"
    result = part1(input)

    assert result == 45
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
