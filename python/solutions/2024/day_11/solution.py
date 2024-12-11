# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/11

from ...base import TextSolution, answer


class Solution(TextSolution):
    _year = 2024
    _day = 11

    # @answer(1234)
    def part_1(self) -> int:
        self.stones = [int(x) for x in self.input.split()]
        for _ in range(25):
            self.blink()
        return len(self.stones)

    # @answer(1234)
    def part_2(self) -> int:
        pass

    def blink(self) -> list[int]:
        new_arrangement = []
        for stone in self.stones:
            if stone == 0:
                new_arrangement.append(1)
            else:
                digit_count = len(str(stone))
                if digit_count % 2 == 0:
                    center = digit_count // 2
                    left = int(str(stone)[:center])
                    right = int(str(stone)[center:])
                    new_arrangement.append(left)
                    new_arrangement.append(right)
                else:
                    new_arrangement.append(stone * 2024)
        self.stones = new_arrangement

    # @answer((1234, 4567))
    # def solve(self) -> tuple[int, int]:
    #     pass
