# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/1

from ...base import StrSplitSolution, answer
from ...utils.parsing import parse_column_ints
from collections import Counter


class Solution(StrSplitSolution):
    _year = 2024
    _day = 1

    @answer(2264607)
    def part_1(self) -> int:
        locations = map(sorted, parse_column_ints(self.input))
        total = 0
        for val1, val2 in zip(*locations):
            total += abs(val1 - val2)
        return total

    @answer(19457120)
    def part_2(self) -> int:
        [list1, list2] = parse_column_ints(self.input)
        freqs = Counter(list2)
        total = 0
        for val in list1:
            total += val * freqs.get(val, 0)
        return total
