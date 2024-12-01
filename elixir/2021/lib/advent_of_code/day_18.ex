defmodule AdventOfCode.Day18 do
  def part1(args) do
    snailfish_numbers = String.split(args, "\n", trim: true)
    |> Enum.map(fn s -> Code.eval_string(s) |> elem(0) end)

    first = List.first(snailfish_numbers)
  end

  @doc """
    iex> AdventOfCode.Day18.add([1,2], [[3,4],5])
    [[1,2],[[3,4],5]]
  """
  def add(sn1, sn2) do
    [sn1, sn2]
  end

  def reduce(sn) do
    case try_explosion(sn) do
      ^sn -> try_split(sn)
      new -> new
    end
  end

  @doc """
      iex> AdventOfCode.Day18.try_explosion([[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]])
      [[[[0,7],4],[7,[[8,4],9]]],[1,1]]
  """
  def try_explosion(sn) do
    do_try_explode(sn, 3)
  end

  def do_try_explode(sn, 0) do
    Enum.reduce_while(sn, sn, fn [l, r], pairs ->
      
    end)
  end

  def do_try_explode(sn, count) do

  end

  @doc """
    iex> AdventOfCode.Day18.try_split([[8, 10], 7])
    [[8, [5,5]], 7]

    iex> AdventOfCode.Day18.try_split([[8, 10], [6, 13], 7])
    [[8, [5,5]], [6, 13], 7]

    iex> AdventOfCode.Day18.try_split([[8, 9], [6, 13], 7])
    [[8, 9], [6, [6,7]], 7]
  """
  def try_split([h, t] = sn)
  when is_integer(h) and h < 10 and is_integer(t) and t < 10
  do
    IO.inspect(sn, label: "h and t < 10")
    sn
  end

  def try_split([h | t] = n) when is_integer(h) and h >= 10 do
    IO.inspect(n, label: "with h >= 10")
    left = floor(h/2)
    right = ceil(h/2)
    [[left, right] | t]
  end

  def try_split([h | t] = n) when is_integer(t) and t >= 10 do
    IO.inspect(n, label: "with t >= 10")
    left = floor(t/2)
    right = ceil(t/2)
    [h | [left, right]]
  end

  def try_split([h | t] = n) when is_integer(h) do
    IO.inspect(n, label: "with h integer")
    [h | try_split(t)]
  end

  def try_split([h | t] = n) when is_list(h) do
    IO.inspect(n, label: "with h list")
    case try_split(h) do
      ^h -> [h | try_split(t)]
      new -> [new | t]
    end

  end

  def try_split([h | t]) when is_list(t) do
    IO.inspect(label: "when t list")
    [h | try_split(t)]
  end

  def try_split(sn) do
    IO.inspect(sn, label: "hmm")
  end

  def part2(args) do
  end
end
