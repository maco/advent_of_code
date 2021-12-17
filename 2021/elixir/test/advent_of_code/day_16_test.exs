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

  test "po chen's input" do
    input = "E058F79802FA00A4C1C496E5C738D860094BDF5F3ED004277DD87BB36C8EA800BDC3891D4AFA212012B64FE21801AB80021712E3CC771006A3E47B8811E4C01900043A1D41686E200DC4B8DB06C001098411C22B30085B2D6B743A6277CF719B28C9EA11AEABB6D200C9E6C6F801F493C7FE13278FFC26467C869BC802839E489C19934D935C984B88460085002F931F7D978740668A8C0139279C00D40401E8D1082318002111CE0F460500BE462F3350CD20AF339A7BB4599DA7B755B9E6B6007D25E87F3D2977543F00016A2DCB029009193D6842A754015CCAF652D6609D2F1EE27B28200C0A4B1DFCC9AC0109F82C4FC17880485E00D4C0010F8D110E118803F0DA1845A932B82E200D41E94AD7977699FED38C0169DD53B986BEE7E00A49A2CE554A73D5A6ED2F64B4804419508B00584019877142180803715224C613009E795E58FA45EA7C04C012D004E7E3FE64C27E3FE64C24FA5D331CFB024E0064DEEB49D0CC401A2004363AC6C8344008641B8351B08010882917E3D1801D2C7CA0124AE32DD3DDE86CF52BBFAAC2420099AC01496269FD65FA583A5A9ECD781A20094CE10A73F5F4EB450200D326D270021A9F8A349F7F897E85A4020CF802F238AEAA8D22D1397BF27A97FD220898600C4926CBAFCD1180087738FD353ECB7FDE94A6FBCAA0C3794875708032D8A1A0084AE378B994AE378B9A8007CD370A6F36C17C9BFCAEF18A73B2028C0A004CBC7D695773FAF1006E52539D2CFD800D24B577E1398C259802D3D23AB00540010A8611260D0002130D23645D3004A6791F22D802931FA4E46B31FA4E4686004A8014805AE0801AC050C38010600580109EC03CC200DD40031F100B166005200898A00690061860072801CE007B001573B5493004248EA553E462EC401A64EE2F6C7E23740094C952AFF031401A95A7192475CACF5E3F988E29627600E724DBA14CBE710C2C4E72302C91D12B0063F2BBFFC6A586A763B89C4DC9A0"
    part1(input)
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
