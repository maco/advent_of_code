defmodule AdventOfCode.Day16 do
  def part1(args) do
    bitlist = Base.decode16!(args)
    {data, _} = decode_packet(bitlist)
    total_versions(data)
  end

  def decode_packet(<<v::3, 4::3, rest::bits>>) do
    IO.puts("decode")
    IO.puts("going to literal")
    {payload, remainder} = literal_value(rest)
    {%{version: v, type: 4, payload: payload},remainder}
  end

  def decode_packet(<<v::3, t::3, rest::bits>>) do
    IO.puts("decode")
    IO.inspect({bits_to_integer(<<v>>),bits_to_integer(<<t>>)}, label: "{v, t}")
    IO.puts("going to operator")
    {payload, remainder} = operator(rest)
    {%{version: v, type: t, payload: payload}, remainder}
  end

  @doc """
      iex> AdventOfCode.Day16.literal_value(<<191, 138, 0::size(2)>>)
      {2021, <<0::3>>}
  """
  def literal_value(bitlist) do
    IO.puts("entering literal")
    {v, remainder} = do_literal_value(bitlist)

    size = bit_size(v)
    <<int::size(size)>> = v
    int

    {int, remainder}
  end

  defp do_literal_value(<<0::1, b::4, rest::bits>>) do
    IO.puts("literal base")
    {<<b::4>>, rest}
  end

  defp do_literal_value(<<_::1, b::4, rest::bits>>) do
    IO.puts("literal recursion")
    {n, remainder} = do_literal_value(rest)
    m = <<b::4>>
    IO.inspect(is_bitstring(m), label: "m is bitstring")
    IO.inspect(bit_size(m), label: "m bit size")
    IO.inspect(bit_size(<< m::bits , n::bits >>), label: "full bit size")
    {<< m::bits , n::bits >>, remainder}
  end

  def operator(<<0::1, len::15, rest::bits>> = bitlist) do
    IO.puts("operator")
    IO.puts("by length")
    len = bits_to_integer(<<len>>)
    <<subpackets::size(len)-bits, remainder::bits>> = rest
    {subpackets_by_bits(subpackets), <<>>} # remainder should be junk?
  end

  def operator(<<1::1, subpackets::11, rest::bits>> = bitlist) do
    IO.puts("operator")
    IO.puts("by number of packets")
    IO.inspect(subpackets, label: "count")
    subpackets = subpackets_by_count(rest, subpackets)
    {subpackets, rest} |> IO.inspect(label: "operator return")
  end

  def subpackets_by_count(remainder, 0), do: []

  def subpackets_by_count(bitlist, count) do
    IO.inspect(count, label: "subpacket")
    {data, remainder} = decode_packet(bitlist)
    IO.inspect(data, label: "data in subpacket")
    [ data | subpackets_by_count(remainder, count - 1)]
  end

  def subpackets_by_bits(<<>>) do
    IO.puts("ran out of bits")
     []
  end

  def subpackets_by_bits(bitlist) do
    IO.puts("inspecting a subpacket")
    {data, remainder} = decode_packet(bitlist)
    IO.inspect(data)
    [ data | subpackets_by_bits(remainder)] |> IO.inspect
  end

  @doc """
      iex> packet = %{payload: [
      ...> %{payload: 10, type: 4, version: 6},
      ...> %{payload: 20, type: 4, version: 2}
      ...>],
      ...>type: 6,
      ...>version: 1}
      iex> AdventOfCode.Day16.total_versions(packet)
      9
  """
  def total_versions(%{version: v, payload: x } = packet) when is_integer(x), do: v

  def total_versions(%{version: v, payload: payload} = packet) do
    Enum.reduce(payload, v, fn subpacket, acc ->
      acc + total_versions(subpacket)
    end)
  end

  defp bits_to_integer(bs) do
    size = bit_size(bs)
    <<int::size(size)>> = bs
    int
  end

  def part2(args) do
  end
end
