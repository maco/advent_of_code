defmodule AdventOfCode.Day10 do
  @corrupt_paren 3
  @corrupt_square 57
  @corrupt_curly 1197
  @corrupt_angle 25137

  @incomplete_paren 1
  @incomplete_square 2
  @incomplete_curly 3
  @incomplete_angle 4

  def part1(args) do
    %{{:corrupt, ")"} => paren, {:corrupt, ">"} => angle, {:corrupt, "]"} => square, {:corrupt, "}"} => curly} =
      String.split(args, "\n", trim: true)
    |> Enum.map(fn line ->
      String.graphemes(line)
      |> analyze_line
    end)
    |> Enum.frequencies()

    @corrupt_paren * paren + @corrupt_square * square + @corrupt_curly * curly + @corrupt_angle * angle
  end

  @doc"""
      iex> AdventOfCode.Day10.analyze_line(["[","]"])
      {:ok}

      iex> AdventOfCode.Day10.analyze_line(["[","<",">","]"])
      {:ok}

      iex> AdventOfCode.Day10.analyze_line(["[","<",">","(",")","]"])
      {:ok}

      iex> AdventOfCode.Day10.analyze_line(["[",")"])
      {:corrupt, ")"}

      iex> AdventOfCode.Day10.analyze_line(["[","(",")"])
      {:incomplete, ["["]}
  """
  def analyze_line(l), do: analyze_line(l, [])
  def analyze_line([], []), do: {:ok} # valid line
  def analyze_line([], acc), do: {:incomplete, acc} # still stuff left pushed onto the stack
  def analyze_line([h|t], acc) when h == "{" or h == "[" or h == "(" or h == "<", do: analyze_line(t, [h|acc])

  def analyze_line([">"|t], ["<"|acc]), do: analyze_line(t, acc)
  def analyze_line([")"|t], ["("|acc]), do: analyze_line(t, acc)
  def analyze_line(["]"|t], ["["|acc]), do: analyze_line(t, acc)
  def analyze_line(["}"|t], ["{"|acc]), do: analyze_line(t, acc)
  def analyze_line([h|_], _), do: {:corrupt, h}

  def part2(args) do
    scores =String.split(args, "\n", trim: true)
      |> Enum.map(fn line ->
        String.graphemes(line)
        |> analyze_line
      end)
      |> Enum.filter(fn
          {:incomplete, _} -> true
          {:ok} -> false
          {:corrupt, _} -> false
      end)
      |> Enum.map(fn {:incomplete, remainder} ->
        complete_line(remainder)
        |> score()
      end)
      |> Enum.sort()

    num = Enum.count(scores)
    Enum.at(scores, floor(num / 2))
  end

  @doc"""
      iex> AdventOfCode.Day10.complete_line(["{","["])
      ["}","]"]
  """
  def complete_line(l), do: Enum.reverse(complete_line(l, []))
  def complete_line([], acc), do: acc
  def complete_line(["<"|t], acc), do: complete_line(t, [">"|acc])
  def complete_line(["("|t], acc), do: complete_line(t, [")"|acc])
  def complete_line(["["|t], acc), do: complete_line(t, ["]"|acc])
  def complete_line(["{"|t], acc), do: complete_line(t, ["}"|acc])

  @doc"""
      iex> AdventOfCode.Day10.score(["}", "}", "]", "]", ")", "}", ")", "]"])
      288957
  """
  def score(chars), do: score(chars, 0)
  def score([], total), do: total
  def score([")"|t], total), do: score(t, total * 5 + @incomplete_paren)
  def score(["]"|t], total), do: score(t, total * 5 + @incomplete_square)
  def score(["}"|t], total), do: score(t, total * 5 + @incomplete_curly)
  def score([">"|t], total), do: score(t, total * 5 + @incomplete_angle)
end
