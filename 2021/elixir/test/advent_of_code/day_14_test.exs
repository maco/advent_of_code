defmodule AdventOfCode.Day14Test do
  use ExUnit.Case
  doctest AdventOfCode.Day14

  import AdventOfCode.Day14

  test "part1" do
    input = """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """
    result = part1(input)

    assert result == 1588
  end

  test "part2" do
    input = """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """
    result = part2(input)

    assert result == 2188189693529
  end
end
