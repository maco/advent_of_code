defmodule AdventOfCode.Day16Test do
  use ExUnit.Case
  doctest AdventOfCode.Day16

  import AdventOfCode.Day16

  # @tag :skip
  test "literal number packet" do
    input = "D2FE28"
    {result, _} = Base.decode16!(input) |> decode_packet()

    assert result[:version] == 6
    assert result[:type] == 4
  end

  # @tag :skip
  test "operator packet with length" do
    input = "38006F45291200"
    {result, _} = Base.decode16!(input) |> decode_packet()

    assert result[:version] == 1
    assert result[:type] == 6
  end

  # @tag :skip
  test "operator packet with count" do
    input = "EE00D40C823060"
    {result, _} = Base.decode16!(input) |> decode_packet()

    assert result[:version] == 7
    assert result[:type] == 3
  end

  test "example 1" do
    input = "8A004A801A8002F478"
    result = part1(input)
    assert result == 16
  end

  test "example 2" do
    input = "620080001611562C8802118E34"
    result = part1(input)
    assert result == 12
  end

  test "example 3" do
    input = "C0015000016115A2E0802F182340"
    result = part1(input)
    assert result == 23
  end

  test "example 4" do
    input = "A0016C880162017C3686B18A3D4780"
    result = part1(input)
    assert result == 31
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
