defmodule AdventOfCode.Day16Test do
  use ExUnit.Case
  doctest AdventOfCode.Day16

  import AdventOfCode.Day16

  @tag :skip
  test "literal number packet" do
    input = "D2FE28"
    result = part1(input)

    assert result
  end

  @tag :skip
  test "operator packet" do
    input = "38006F45291200"
    result = part1(input)
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
