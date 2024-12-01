defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """
    11 = part1(input)
  end

  test "part2" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """
    31 = part2(input)
  end
end
