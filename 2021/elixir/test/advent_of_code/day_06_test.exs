defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = "3,4,3,1,2"
    result = part1(input)

    assert result == 5934
  end

  @tag :skip
  test "part2" do
    input = "3,4,3,1,2"
    result = part2(input)

    assert result == 26984457539
  end
end
