defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Parsing

  test "two columns of ints" do
    input = """
    1   2
    3   4
    5   6
    """

    expected = [[1, 3, 5], [2, 4, 6]]

    assert expected == parse_columns_ints(input)
  end

  test "three columns of ints" do
    input = """
    1   2   6
    3   4   7
    5   6   8
    """

    expected = [[1, 3, 5], [2, 4, 6], [6, 7, 8]]

    assert expected == parse_columns_ints(input)
  end

  test "rows of ints" do
    input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    expected = [
      [7, 6, 4, 2, 1],
      [1, 2, 7, 8, 9],
      [9, 7, 6, 2, 1],
      [1, 3, 2, 4, 5],
      [8, 6, 4, 4, 1],
      [1, 3, 6, 7, 9]
    ]

    assert expected == parse_rows_ints(input)
  end
end
