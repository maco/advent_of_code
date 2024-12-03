# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/3

from ...base import TextSolution, answer
import re


class Solution(TextSolution):
    _year = 2024
    _day = 3

    @answer(161289189)
    def part_1(self) -> int:
        captures = re.findall(r"mul\((\d{1,3}),(\d{1,3})\)", self.input)
        total = 0
        for x, y in captures:
            total += int(x) * int(y)
        return total

    @answer(83595109)
    def part_2(self) -> int:
        captures = re.findall(
            r"(mul)\((\d{1,3}),(\d{1,3})\)|(don\'t\(\))|(do\(\))", self.input
        )
        total = 0
        enabled = True
        for capture in captures:
            match capture:
                case ("mul", x, y, _, _):
                    total += int(x) * int(y) if enabled else 0
                case (_, _, _, "don't()", _):
                    enabled = False
                case (_, _, _, _, "do()"):
                    enabled = True
        return total
