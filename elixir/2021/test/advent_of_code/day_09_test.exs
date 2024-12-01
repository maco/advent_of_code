defmodule AdventOfCode.Day09Test do
  use ExUnit.Case
  doctest AdventOfCode.Day09

  import AdventOfCode.Day09

  test "part1" do
    input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """
    result = part1(input)

    assert result == 15
  end

  # @tag :skip
  test "part2" do
    input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """
    result = part2(input)

    assert result == 1134
  end

  test "bigger part2" do
    input = """
    21999432101234
    39878949212345
    98567898923434
    87678967894323
    98999656789212
    """
    result = part2(input)

    assert result == 28 * 9 * 14
  end
end
