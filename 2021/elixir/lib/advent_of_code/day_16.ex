defmodule AdventOfCode.Day16 do
  def part1(args) do
    bitlist = Base.decode16!(args)
    decode_packet(bitlist)
  end

  def decode_packet(bitlist) do
    <<v::3, t::3, rest::bits>> = bitlist

    case t do
      4 -> literal_value(rest)
      _ -> operator(rest)
    end
  end

  # TODO
  @doc """
      iex> AdventOfCode.Day16.literal_value(<<191, 138, 0::size(2)>>)
      2021
  """
  def literal_value(bitlist) do
    <<a::1, b::size(4), rest::bits>> = bitlist
    IO.inspect({a, b}, label: "a and b")
    if match?(<<^a::1>>, <<0::1>>) do
      IO.puts("base case")
      <<b::4>>
    else
      IO.puts("else")
      n = literal_value(rest)
      IO.inspect(is_bitstring(<<b::4>>), label: "b is bitstring")
      IO.inspect(is_bitstring(n), label: "n is bitstring")
      << <<b::4>>, n >>
    end
  end

  def operator(bitlist) do
    IO.puts("operator")
    <<mode::1, rest::bits>> = bitlist
    case mode do
      0 ->
        IO.puts("by length")
        <<len::15, rest2::bits>> = bitlist
        <<subpackets::size(len)>> = rest2
        decode_packet(subpackets)
      1 ->
        IO.puts("by number of packets")
        <<subpackets::11, rest2::bits>> = bitlist
        decode_packet(rest2)
    end
  end

  def part2(args) do
  end
end
