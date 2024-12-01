defmodule AdventOfCode.Day12Test do
  use ExUnit.Case
  doctest AdventOfCode.Day12

  import AdventOfCode.Day12

  test "part1 A" do
    input = """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """
    result = part1(input)

    assert result == 10
  end

  test "part2" do
    input = """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """
    result = part2(input)

    assert result == 36
  end
end
