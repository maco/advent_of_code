defmodule Mix.Tasks.D01.P2b do
  use Mix.Task

  import AdventOfCode.Day01b

  @shortdoc "Day 01 Part 2"
  def run(args) do
    input = AdventOfCode.Input.get!(1, 2021)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
