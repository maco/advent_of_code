defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Parsing

  test "two columns" do
    input = """
    1   2
    3   4
    5   6
    """

    expected = [[1, 3, 5], [2, 4, 6]]

    assert expected == parse_columns_ints(input)
  end

  test "three columns" do
    input = """
    1   2   6
    3   4   7
    5   6   8
    """

    expected = [[1, 3, 5], [2, 4, 6], [6, 7, 8]]

    assert expected == parse_columns_ints(input)
  end
end
