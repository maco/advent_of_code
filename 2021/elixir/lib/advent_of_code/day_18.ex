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
      iex> AdventOfCode.Day18.try_explosion([[[[[9,8],1],2],3],4])
      [[[[0,9],2],3],4]

      # iex> AdventOfCode.Day18.try_explosion([7,[6,[5,[4,[3,2]]]]])
      # [7,[6,[5,[7,0]]]]

      # iex> AdventOfCode.Day18.try_explosion([[6,[5,[4,[3,2]]]],1])
      # [[6,[5,[7,0]]],3]

      # iex> AdventOfCode.Day18.try_explosion([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]])
      # [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]

      # iex> AdventOfCode.Day18.try_explosion([[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]])
      # [[3,[2,[8,0]]],[9,[5,[7,0]]]]

      # iex> AdventOfCode.Day18.try_explosion([[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]])
      # [[[[0,7],4],[7,[[8,4],9]]],[1,1]]
  """
  def try_explosion(sn) do
    do_try_explode(sn, 1)
  end

  def do_try_explode([[l,r] | []], depth) do
    IO.inspect("bottomed out")
    IO.inspect(depth, label: "depth")
    [l, r]
  end

  def do_try_explode([h | []], depth) do
    IO.inspect("no tail")
    IO.inspect(depth, label: "depth")
    case do_try_explode(h, depth) do
      {:explode, %{left: l, right: r}} ->
        {}
      n ->
        n
    end
  end

  def do_try_explode([l, r], 5)  when is_integer(l) and is_integer(r) do
    IO.puts("level 4")
    IO.inspect([l,r], label: "4-deep pair")
    # IO.inspect(sn, label: "sn")
    # [l, r] = Enum.find(sn, fn x -> is_list(x) end) |> IO.inspect(label: "explode this")
    {:explode, %{left: l, right: r}}
  end

  def do_try_explode([l, r], depth) when is_integer(l) and is_integer(r) do
    IO.inspect([l, r], label: "2 integers")
    IO.inspect(depth, label: "depth")
    [l, r]
  end

  def do_try_explode([h | t], depth) when is_integer(h) and is_integer(t) do
    IO.inspect([h | t], label: "integers")
    IO.inspect(depth, label: "depth")
    [h | t]
  end



  def do_try_explode([h | t], depth) when is_integer(h) do
    IO.inspect(h, label: "h")
    IO.inspect(t, label: "with list")
    IO.inspect(depth, label: "depth")
    [h | do_try_explode(t, depth + 1)]
  end

  def do_try_explode([h | t], depth) do
    IO.inspect(h, label: "h")
    IO.inspect(t, label: "t")
    IO.inspect(depth, label: "depth")
    do_try_explode(h, depth + 1)
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
    # IO.inspect(sn, label: "h and t < 10")
    sn
  end

  def try_split([h | t] = n) when is_integer(h) and h >= 10 do
    # IO.inspect(n, label: "with h >= 10")
    left = floor(h/2)
    right = ceil(h/2)
    [[left, right] | t]
  end

  def try_split([h | t] = n) when is_integer(t) and t >= 10 do
    # IO.inspect(n, label: "with t >= 10")
    left = floor(t/2)
    right = ceil(t/2)
    [h | [left, right]]
  end

  def try_split([h | t] = n) when is_integer(h) do
    # IO.inspect(n, label: "with h integer")
    [h | try_split(t)]
  end

  def try_split([h | t] = n) when is_list(h) do
    # IO.inspect(n, label: "with h list")
    case try_split(h) do
      ^h -> [h | try_split(t)]
      new -> [new | t]
    end

  end

  def try_split([h | t]) when is_list(t) do
    # IO.inspect(label: "when t list")
    [h | try_split(t)]
  end

  def try_split(sn) do
    # IO.inspect(sn, label: "hmm")
  end

  def part2(args) do
  end
end
