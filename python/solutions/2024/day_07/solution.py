# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/7

from ...base import StrSplitSolution, answer
import operator
from typing import Callable


class Solution(StrSplitSolution):
    _year = 2024
    _day = 7

    # @answer((1234, 4567))
    def part_1(self) -> int:
        lines = self._parse()

        return sum(
            line[0]
            for line in lines
            if line[0] in self._possible_results(line[1], [operator.add, operator.mul])
        )

    def part_2(self) -> int:
        lines = self._parse()

        return sum(
            line[0]
            for line in lines
            if line[0] in self._possible_results(line[1], [operator.add, operator.mul, self._concatenate])
        )

    def _parse(self):
        lines = []
        for line in self.input:
            [test, num_str] = line.split(":")
            nums = []
            for num in num_str.split():
                nums.append(int(num))
            lines.append((int(test), nums))
        return lines

    def _concatenate(self, x: int, y: int) -> int:
        return int(str(x) + str(y))

    def _possible_results(self, nums: list[int], ops: list[Callable]) -> list[int]:
        current = nums.pop()
        if len(nums) > 0:
            subresults = self._possible_results(nums, ops)
            new_results = []
            for sub in subresults:
                for op in ops:
                    new_results.append(op(sub, current))
            return new_results
        else:
            return [current]
