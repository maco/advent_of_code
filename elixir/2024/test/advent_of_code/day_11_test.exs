defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  test "blink once" do
    input = [0, 1, 10, 99, 999]
    [1, 2024, 1, 0, 9, 9, 2_021_976] = blink(input)
  end

  test "part1" do
    input = "125 17"
    55312 = part1(input)
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
