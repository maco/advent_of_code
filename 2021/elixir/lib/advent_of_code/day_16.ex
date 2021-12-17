defmodule AdventOfCode.Day16 do
  def part1(args) do
    bitlist = String.trim(args) |> Base.decode16!()
    {data, _} = decode_packet(bitlist)
    total_versions(data)
  end

  def decode_packet(<<v::3, 4::3, rest::bits>>) do
    {payload, remainder} = literal_value(rest)
    {%{version: v, type: 4, payload: payload}, remainder}
  end

  def decode_packet(<<v::3, t::3, rest::bits>>) do
    {payload, remainder} = operator(rest)
    {%{version: v, type: t, payload: payload}, remainder}
  end

  @doc """
      iex> AdventOfCode.Day16.literal_value(<<191, 138, 0::size(2)>>)
      {2021, <<0::3>>}
  """
  def literal_value(bitlist) do
    {v, remainder} = do_literal_value(bitlist)

    size = bit_size(v)
    <<int::size(size)>> = v

    {int, remainder}
  end

  defp do_literal_value(<<0::1, b::4, rest::bits>>) do
    {<<b::4>>, rest}
  end

  defp do_literal_value(<<_::1, b::4, rest::bits>>) do
    {n, remainder} = do_literal_value(rest)
    m = <<b::4>>
    {<<m::bits, n::bits>>, remainder}
  end

  def operator(<<0::1, len::integer-size(15), rest::bits>>) do
    # IO.puts("operator")
    <<subpackets::size(len)-bits, remainder::bits>> = rest
    {subpackets_by_bits(subpackets), remainder}
  end

  def operator(<<1::1, count::integer-size(11), rest::bits>>) do
    # IO.puts("operator")
    subpackets_by_count(rest, count)
  end

  def subpackets_by_count(bitlist, 0), do: {[], bitlist}

  def subpackets_by_count(bitlist, count) do
    {data, rest} = decode_packet(bitlist)
    {subdata, remainder} = subpackets_by_count(rest, count - 1)
    {[data | subdata], remainder}
  end

  def subpackets_by_bits(<<>>) do
    []
  end

  def subpackets_by_bits(bitlist) do
    {data, remainder} = decode_packet(bitlist)
    [data | subpackets_by_bits(remainder)]
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
  def total_versions(%{version: v, payload: x}) when is_integer(x), do: v

  def total_versions(%{version: v, payload: payload}) do
    Enum.reduce(payload, v, fn subpacket, acc ->
      acc + total_versions(subpacket)
    end)
  end

  def part2(args) do
  end
end
