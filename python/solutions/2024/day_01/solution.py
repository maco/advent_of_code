# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/1

from ...base import StrSplitSolution, answer


class Solution(StrSplitSolution):
    _year = 2024
    _day = 1

    # @answer(1234)
    def part_1(self) -> int:
        list1: list[int] = []
        list2: list[int] = []
        total: int = 0

        for line in self.input:
            [first, second] = line.split()
            list1.append(int(first))
            list2.append(int(second))

        list1.sort()
        list2.sort()

        for (first, second) in zip(list1, list2):
            total = total + abs(first - second)

        return total

    # @answer(1234)
    def part_2(self) -> int:
        pass

    # @answer((1234, 4567))
    # def solve(self) -> tuple[int, int]:
    #     pass
