defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1" do
    input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    2 = part1(input)
  end

  test "part2" do
    input1 = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    4 =
      part2(input1)

    input2 = """
    1 6 7 8 9
    4 5 6 7 1
    1 7 2 8 3
    1 3 2 6 7
    1 7 4 6 7
    5 3 4 3 2
    """

    5 =
      part2(input2)
  end
end
