# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/3

from ...base import TextSolution, answer
import re


class Solution(TextSolution):
    _year = 2024
    _day = 3

    @answer(161289189)
    def part_1(self) -> int:
        # input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
        captures = re.findall(r'mul\((\d{1,3}),(\d{1,3})\)', self.input)
        total = 0
        for (x, y) in captures:
            total += int(x) * int(y)
        return total

    # @answer(1234)
    def part_2(self) -> int:
        captures = re.findall(r'(mul)\((\d{1,3}),(\d{1,3})\)|(don\'t\(\))|(do\(\))', self.input)
        total = 0
        enabled = True
        for capture in captures:
            match capture:
                case ('mul', x, y, _, _):
                    total += int(x) * int(y) if enabled else 0
                case(_, _, _, "don't()", _):
                    enabled = False
                case(_, _, _, _, "do()"):
                    enabled = True
        return total

    # @answer((1234, 4567))
    # def solve(self) -> tuple[int, int]:
    #     pass
