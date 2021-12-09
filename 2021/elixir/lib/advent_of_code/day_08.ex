defmodule AdventOfCode.Day08 do
  def part1(args) do
    data = parse(args)

    output = Enum.reduce(data, [], fn %{out: out}, acc ->
      out ++ acc
    end)

    find_unique(output)
    |> Enum.count()

  end

  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "|")
    end)
    |> Enum.map(fn [l, r] ->
      %{in: String.split(l, " ", trim: true),
        out: String.split(r, " ", trim: true)}
    end)
  end

  def find_unique(input) do
    Enum.filter(input, fn digit ->
      case String.length(digit) do
        2 -> true
        3 -> true
        4 -> true
        7 -> true
        _ -> false
      end
    end)
  end

  @doc"""
      iex> AdventOfCode.Day08.part2("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf")
      5353
  """
  def part2(args) do
    data = parse(args)
    Enum.map(data, fn line ->
      decode_input(line)
      |> decode_output(line)
    end)
    |> Enum.sum()
  end

  def decode_output(key, %{in: _rosetta, out: out}) do
    Enum.map(out, fn digit ->
      sorted = String.graphemes(digit) |> Enum.sort() |> Enum.join()
      Map.get(key, sorted) |> IO.inspect
    end)
    |> Enum.join()
    |> String.to_integer()
  end

  @doc"""
      iex> data = %{in: ["acedgfb", "cdfbe", "gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab"], out: nil}
      iex> AdventOfCode.Day08.decode_input(data)
      ...> %{"ab" => "1", "abd" => 7, "abcdeg" => "0", "abef" => "4", "bcdefg" => "6", "abcdef" => "9", "abcdf" => "3", "acdfg" => "2", "bcdef" => "5", "abcdefg" => "8"}
  """
  def decode_input(%{in: rosetta, out: _out}) do
    splitted = Enum.map(rosetta, fn string -> String.graphemes(string) |> Enum.sort() end) |> IO.inspect
    one = Enum.find(splitted, fn option -> Enum.count(option) == 2 end)
    seven = Enum.find(splitted, fn option -> Enum.count(option) == 3 end)
    four = Enum.find(splitted, fn option -> Enum.count(option) == 4 end)
    eight = Enum.find(splitted, fn option -> Enum.count(option) == 7 end)

    zero_six_nine =
      Enum.filter(splitted, fn option -> Enum.count(option) == 6 end)

    two_three_five =
      Enum.filter(splitted, fn option -> Enum.count(option) == 5 end)

    [a] = seven -- one # a must be this one
    {c, f} = find_c_and_f(one, zero_six_nine)

    {[six], zero_nine} = find_six(zero_six_nine, c)
    {d, b, nine, zero} = find_d_nine_zero(four -- one, zero_nine) # d is in four but not one

    # still need e, g, two, three, five,

    {[five], two_three} = lacks_c(two_three_five, c)

    eg = eight -- [a, b, c, d, f]
    {e, g, two, three} = find_eg_two_three(two_three, eg, f)

    %{
      Enum.join(zero) => "0",
      Enum.join(one) => "1",
      Enum.join(two) => "2",
      Enum.join(three) => "3",
      Enum.join(four) => "4",
      Enum.join(five) => "5",
      Enum.join(six) => "6",
      Enum.join(seven) => "7",
      Enum.join(eight) => "8",
      Enum.join(nine) => "9" }
  end

  @doc"""
      iex> zsn = [
      ...>   ["b", "c", "d", "e", "f", "g"],
      ...>   ["a", "c", "d", "e", "f", "g"],
      ...>   ["a", "b", "d", "e", "f", "g"]
      ...> ]
      iex> AdventOfCode.Day08.find_c_and_f(["b", "e"], zsn)
      {"b", "e"}

  """
  def find_c_and_f(possibilities, zero_six_nine) do
    c_and_f = Enum.map(zero_six_nine, fn zsn ->
      Enum.reject(zsn, fn letter ->
        not Enum.any?(possibilities, fn l -> l == letter end)
      end)
    end)
    |> List.flatten()
    |> Enum.frequencies()
    {
      Enum.find(c_and_f, fn {letter, count} -> count == 2 end) |> elem(0),
      Enum.find(c_and_f, fn {letter, count} -> count == 3 end) |> elem(0)
    }
  end

  @doc"""
      iex> zsn = [
      ...>   ["b", "c", "d", "e", "f", "g"],
      ...>   ["a", "c", "d", "e", "f", "g"],
      ...>   ["a", "b", "d", "e", "f", "g"]
      ...> ]
      iex> AdventOfCode.Day08.find_six(zsn, "b")
      {[["a", "c", "d", "e", "f", "g"]], [["b", "c", "d", "e", "f", "g"], ["a", "b", "d", "e", "f", "g"]]}
  """
  def find_six(possibilties, c) do
    Enum.split_with(possibilties, fn option ->
      not Enum.any?(option, fn l -> l == c end)
    end)
  end


  @doc"""
      iex> AdventOfCode.Day08.find_d_nine_zero(["c", "g"], [["b", "c", "d", "e", "f", "g"], ["a", "b", "d", "e", "f", "g"]])
      {"c", "g", ["b", "c", "d", "e", "f", "g"], ["a", "b", "d", "e", "f", "g"]}
  """
  def find_d_nine_zero(possible_ds, nine_zero) do
    # d is in nine but not in zero; both have b
    d_and_b = Enum.map(nine_zero, fn zsn ->
      Enum.reject(zsn, fn letter ->
        not Enum.any?(possible_ds, fn l -> l == letter end)
      end)
    end)
    |> List.flatten()
    |> Enum.frequencies()

    {d, b} =
    {
      Enum.find(d_and_b, fn {letter, count} -> count == 1 end) |> elem(0),
      Enum.find(d_and_b, fn {letter, count} -> count == 2 end) |> elem(0)
    }

    # nine has d, but zero doesn't
    {[zero], [nine]} = Enum.split_with(nine_zero, fn option ->
      not Enum.any?(option, fn l -> l == d end)
    end)

    {d, b, nine, zero}
  end

  @doc"""
      iex> ttf = [
      ...>   ["c", "d", "e", "f", "g"],
      ...>   ["b", "c", "d", "e", "f"],
      ...>   ["a", "b", "c", "d", "f"]
      ...> ]
      iex> c = "b"
      iex> AdventOfCode.Day08.lacks_c(ttf, c)
      {[["c", "d", "e", "f", "g"]],[["b", "c", "d", "e", "f"], ["a", "b", "c", "d", "f"]]}
  """
  def lacks_c(possibilities, c) do
    Enum.split_with(possibilities, fn option ->
      not Enum.any?(option, fn l -> l == c end)
    end)
  end

  @doc"""
      iex> tt = [["b", "c", "d", "e", "f"], ["a", "b", "c", "d", "f"]]
      iex> eg = ["a", "f"]
      iex> f = "e"
      iex> AdventOfCode.Day08.find_eg_two_three(tt, eg, f)

  """
  def find_eg_two_three(two_three, eg, f) do
    # three has f, but two doesn't
    {[two], [three]} = Enum.split_with(two_three, fn option ->
      not Enum.any?(option, fn l -> l == f end)
    end)


    # e is in 2, f is in 3, and g is in both
    e_and_g = Enum.map(two_three, fn tt ->
      Enum.reject(tt, fn letter ->
        not Enum.any?(eg, fn l -> l == letter end)
      end)
    end)
    |> List.flatten()
    |> Enum.frequencies()

    {e, g} =
    {
      Enum.find(e_and_g, fn {letter, count} -> count == 1 end) |> elem(0),
      Enum.find(e_and_g, fn {letter, count} -> count == 2 end) |> elem(0)
    }


    {e, g, two, three}

  end

  # @doc"""
  #     iex> AdventOfCode.Day08.find_d(["c", "g"], [["c"], []])
  # """
  # def find_d(d, zero_and_nine) do
  #   unique = zero_and_nine
  #   |> Enum.frequencies()
  #   |> Enum.filter(fn {letter, count} -> count == 1 end)
  #   |> Enum.map(& elem(&1, 0))
  #   |> IO.inspect(label: "unique from 0 and 9")

  #   IO.inspect(d, label: "d possibilities")
  # end
end
