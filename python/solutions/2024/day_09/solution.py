# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/9

from ...base import TextSolution, answer


class Solution(TextSolution):
    _year = 2024
    _day = 9

    # @answer(1234)
    def part_1(self) -> int:
        compacted = list(self.input)
        self.disk = []

        for index, char in enumerate(compacted):
            block_len = int(char)

            if index % 2 == 0:
                for _i in range(block_len):
                    self.disk.append(index // 2)
            else:
                for _i in range(block_len):
                    self.disk.append(None)

        left_pointer = 0
        right_pointer = (
            len(self.disk) - 1 if self.disk[-1] is not None else len(self.disk) - 2
        )

        while left_pointer < right_pointer:
            if self.disk[left_pointer] is None and self.disk[right_pointer] is not None:
                self._move_block(left_pointer, right_pointer)
                right_pointer -= 1
                left_pointer += 1
            elif self.disk[left_pointer] is not None:
                left_pointer += 1
            else:
                right_pointer -= 1

        total = 0
        for idx, num in enumerate(self.disk):
            if num is None:
                break
            total += idx * num
        return total

    def _move_block(self, left_index, right_index):
        self.disk[left_index] = self.disk[right_index]
        self.disk[right_index] = None

    # @answer(1234)
    def part_2(self) -> int:
        pass

    # @answer((1234, 4567))
    # def solve(self) -> tuple[int, int]:
    #     pass
