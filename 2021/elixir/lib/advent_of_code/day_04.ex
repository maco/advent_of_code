defmodule AdventOfCode.Day04 do
  def part1(args) do
    {numbers, boards} = String.split(args, "\n", trim: true) |> numbers_and_boards()

    {n, [winner | _]} = Enum.reduce_while(numbers, boards, fn n, b ->
      {updated, winners} = play_number(n, b)
      if Enum.count(winners) > 0 do
        {:halt, {n, winners}}
      else
        {:cont, updated}
      end
    end)

    score_board(winner) * n
  end


  def part2(args) do
    {numbers, boards} = String.split(args, "\n", trim: true) |> numbers_and_boards()

    {n, [loser|_]} = Enum.reduce_while(numbers, boards, fn
      n, b when length(b) == 1 ->
        {updated, winners} = play_number(n, b)
        if updated == winners do
          {:halt, {n, winners}}
        else
          {:cont, updated}
        end
      n, b ->
        {updated, winners} = play_number(n, b)
        if Enum.count(winners) > 0 do
          losers = Enum.reject(updated, fn board ->
            Enum.any?(winners, fn w ->
              w == board
            end)
          end)
          {:cont, losers}
        else
          {:cont, updated}
        end
    end)

    score_board(loser) * n
  end

  def play_number(n, boards) do
    new_boards = Enum.map(boards, &update_board(n, &1))
    winning_boards = Enum.filter(new_boards, &is_winner(&1))
    {new_boards, winning_boards}
  end

  @doc"""
      iex> AdventOfCode.Day04.update_board(13, [
      ...> [[22, false], [13, false], [17, false], [11, false], [0, false]],
      ...> [[8, true], [2, true], [23, true], [4, true], [24, true]],
      ...> [[21, false], [9, false], [14, false], [16, false], [7, false]],
      ...> [[6, false], [10, false], [3, false], [18, false], [5, false]],
      ...> [[1, false], [12, false], [20, false], [15, false], [19, false]]])
      [
      [[22, false], [13, true], [17, false], [11, false], [0, false]],
      [[8, true], [2, true], [23, true], [4, true], [24, true]],
      [[21, false], [9, false], [14, false], [16, false], [7, false]],
      [[6, false], [10, false], [3, false], [18, false], [5, false]],
      [[1, false], [12, false], [20, false], [15, false], [19, false]]]
  """
  def update_board(num, board) do
    Enum.map(board, &update_row(num, &1))
  end

  @doc"""
      iex> AdventOfCode.Day04.update_row(4, [[8, false], [2, false], [23, false], [4, false], [24, false]])
      [[8, false], [2, false], [23, false], [4, true], [24, false]]
  """
  def update_row(num, row) do
    # for [^num, _] <- row, do: [num, true]
    Enum.map(row, fn
      [^num, _] -> [num, true]
      [x, val] -> [x, val]
    end)
  end

  @doc"""
      iex> AdventOfCode.Day04.score_board([
      ...> [[22, false], [13, false], [17, false], [11, false], [0, false]],
      ...> [[8, true], [2, true], [23, true], [4, true], [24, true]],
      ...> [[21, false], [9, false], [14, false], [16, false], [7, false]],
      ...> [[6, false], [10, false], [3, false], [18, false], [5, false]],
      ...> [[1, false], [12, false], [20, false], [15, false], [19, false]]])
      239
  """
  def score_board(board) do
    List.flatten(board)
    |> Enum.chunk_every(2)
    |> Enum.reduce(0, fn
      [_x, true], acc ->
        acc
      [x, false], acc ->
        acc + x
      end)
  end

  @doc"""
      iex> AdventOfCode.Day04.is_winner([[[22, false], [13, false], [17, false], [11, false], [0, false]],
      ...> [[8, true], [2, true], [23, true], [4, true], [24, true]],
      ...> [[21, false], [9, false], [14, false], [16, false], [7, false]],
      ...> [[6, false], [10, false], [3, false], [18, false], [5, false]],
      ...> [[1, false], [12, false], [20, false], [15, false], [19, false]]])
      true

      iex> AdventOfCode.Day04.is_winner([[[22, false], [13, false], [17, false], [11, false], [0, true]],
      ...> [[8, false], [2, false], [23, false], [4, false], [24, true]],
      ...> [[21, false], [9, false], [14, false], [16, false], [7, true]],
      ...> [[6, false], [10, false], [3, false], [18, false], [5, true]],
      ...> [[1, false], [12, false], [20, false], [15, false], [19, true]]])
      true

      iex> AdventOfCode.Day04.is_winner([[[22, false], [13, false], [17, false], [11, false], [0, true]],
      ...> [[8, false], [2, false], [23, false], [4, false], [24, true]],
      ...> [[21, false], [9, false], [14, false], [16, false], [7, true]],
      ...> [[6, false], [10, false], [3, false], [18, false], [5, true]],
      ...> [[1, false], [12, false], [20, false], [15, false], [19, false]]])
      false

  """
  def is_winner(board) do
    check_rows(board) or check_columns(board)
  end

  @doc"""
      iex> AdventOfCode.Day04.check_row([[8, true], [2, true], [23, true], [4, true], [24, true]])
      true

      iex> AdventOfCode.Day04.check_row([[8, true], [2, true], [23, true], [4, false], [24, true]])
      false
  """
  def check_row(row) do
    matching = for [r, true] <- row, do: r
    Enum.count(matching) == Enum.count(row)
  end

  @doc"""
      iex> AdventOfCode.Day04.check_rows([[[8, false], [2, true], [23, true], [4, true], [24, true]],
      ...> [[8, true], [2, true], [23, true], [4, true], [24, true]]])
      true

      iex> AdventOfCode.Day04.check_rows([[[8, true], [2, false], [23, true], [4, false], [24, true]],
      ...> [[8, true], [2, true], [23, true], [4, false], [24, true]]])
      false

  """
  def check_rows(rows) do
    Enum.map(rows, &check_row/1) |> Enum.any?()
  end

  @doc"""
      iex> AdventOfCode.Day04.check_columns(
      ...> [[[8, true], [2, false], [23, false]],
      ...> [[4, true], [24, false], [25, false]],
      ...> [[8, true], [2, false], [23, false]],
      ...> [[4, true], [24, false], [25, false]]])
      true

      iex> AdventOfCode.Day04.check_columns(
      ...> [[[8, true], [2, false], [23, false]],
      ...> [[4, false], [24, false], [25, false]],
      ...> [[8, true], [2, false], [23, false]],
      ...> [[4, true], [24, false], [25, false]]])
      false

  """
  def check_columns(board) do
    board |> Enum.zip() |> Enum.map(&Tuple.to_list/1) |> check_rows()
  end

  defp numbers_and_boards([n | b]) do
    numbers = String.split(n, ",")
      |> Enum.map(&String.to_integer/1)
    boards = Enum.chunk_every(b, 5)
      |> Enum.map(fn board ->
        Enum.map(board, fn row ->
          String.split(row, "\s", trim: true)
          |> Enum.map(fn number -> [String.to_integer(number), false] end)
        end)
      end)


    {numbers, boards}
  end
end
