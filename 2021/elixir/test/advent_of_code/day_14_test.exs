defmodule AdventOfCode.Day14Test do
  use ExUnit.Case
  doctest AdventOfCode.Day14

  import AdventOfCode.Day14
  @tag :skip
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

  @tag :skip
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

  test "evert" do
    input = """
    PFVKOBSHPSPOOOCOOHBP

    FV -> C
    CP -> K
    FS -> K
    VF -> N
    HN -> F
    FF -> N
    SS -> K
    VS -> V
    BV -> F
    HC -> K
    BP -> F
    OV -> N
    BF -> V
    VH -> V
    PF -> N
    FC -> S
    CS -> B
    FK -> N
    VK -> H
    FN -> P
    SH -> V
    CV -> K
    HP -> K
    HO -> C
    NO -> V
    CK -> C
    VB -> S
    OC -> N
    NS -> C
    NF -> H
    SF -> N
    NK -> S
    NP -> P
    OO -> S
    NH -> C
    BC -> H
    KS -> H
    PV -> O
    KO -> K
    OK -> H
    OH -> H
    BH -> F
    NB -> B
    FH -> N
    HV -> F
    BN -> S
    ON -> V
    CB -> V
    CF -> H
    FB -> S
    KF -> S
    PS -> P
    OB -> C
    NN -> K
    KV -> C
    BK -> H
    SN -> S
    NC -> H
    PK -> B
    PC -> H
    KN -> S
    VO -> V
    FO -> K
    CH -> B
    PH -> N
    SO -> C
    KH -> S
    HB -> V
    HH -> B
    BB -> H
    SC -> V
    HS -> K
    SP -> V
    KB -> N
    VN -> H
    HK -> H
    KP -> K
    OP -> F
    CO -> B
    VP -> H
    OS -> N
    OF -> H
    KK -> N
    CC -> K
    BS -> C
    VV -> O
    CN -> H
    PB -> P
    BO -> N
    SB -> H
    FP -> F
    SK -> F
    PO -> S
    KC -> H
    VC -> H
    NV -> N
    HF -> B
    PN -> F
    SV -> K
    PP -> K
    """
    result = part2(input)

    assert result == 3390034818249
  end

end
