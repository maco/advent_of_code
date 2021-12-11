defmodule AdventOfCode.Day11Test do
  use ExUnit.Case
  doctest AdventOfCode.Day11

  import AdventOfCode.Day11

  # @tag :skip
  test "part1" do
    input = """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """
    result = part1(input)

    assert result == 1656
  end

  @tag :skip
  test "after step 1" do
    input = """
    6594254334
    3856965822
    6375667284
    7252447257
    7468496589
    5278635756
    3287952832
    7993992245
    5957959665
    6394862637
    """
    {result, flashes} = parse(input) |> do_step(0)

    grid = show_grid(result, "test output")

    # assert grid == """
    #   8807476555
    #   5089087054
    #   8597889608
    #   8485769600
    #   8700908800
    #   6600088989
    #   6800005943
    #   0000007456
    #   9000000876
    #   8700006848
    # """
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
