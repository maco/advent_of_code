# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/1

from ...base import StrSplitSolution, answer
from ...utils.parsing import parse_column_ints


class Solution(StrSplitSolution):
    _year = 2024
    _day = 1

    @answer(2264607)
    def part_1(self) -> int:
        [list1, list2] = parse_column_ints(self.input)

        total: int = 0

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
