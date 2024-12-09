defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    41 = part1(input)
  end

  test "part2" do
    input = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    6 = part2(input)
  end

  test "small loop test" do
    # LiquidityC on Twitch provided this sample input
    # to see if how I stored vectors was the issue
    input = """
    .#.
    -+#
    .|.
    .|.
    .|.
    .^.
    .#.
    """

    1 = part2(input)
  end

  test "very small loop test" do
    input = """
    ##.
    ..#
    ...
    ^#.
    """

    0 = part2(input)
  end
end
