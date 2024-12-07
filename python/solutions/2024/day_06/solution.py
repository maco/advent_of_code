# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/6

from ...base import StrSplitSolution, answer


class Solution(StrSplitSolution):
    _year = 2024
    _day = 6

    @answer(5095)
    def part_1(self) -> int:
        self.grid = [list(line) for line in self.input]
        self.height = len(self.grid)
        self.width = len(self.grid[0])
        self.seen = set()
        self.vector = (-1, 0)
        self.pos = self._find_start()

        while True:
            self.seen.add(self.pos)
            (row, col) = self.pos
            (row_vec, col_vec) = self.vector
            future_row = row + row_vec
            future_col = col + col_vec
            if not self._on_board((future_row, future_col)):
                break
            if self.grid[future_row][future_col] == "#":
                self._turn()
            else:
                self.pos = (future_row, future_col)
        return len(self.seen)


    # @answer(1234)
    def part_2(self) -> int:
        pass


    def _on_board(self, position: tuple[int, int]) -> bool:
        print(position)
        (row, col) = position
        return 0 <= row < self.height and 0 <= col < self.width

    def _turn(self) -> tuple[int, int]:
        if self.vector == (-1, 0):
            self.vector = (0, 1)
        elif self.vector == (0, 1):
            self.vector = (1, 0)
        elif self.vector == (1, 0):
            self.vector = (0, -1)
        elif self.vector == (0, -1):
            self.vector = (-1, 0)

    def _find_start(self) -> tuple[int, int]:
        for row, line in enumerate(self.grid):
            for col, val in enumerate(line):
                if val == "^":
                    return (row, col)
        raise("missing start")

    # @answer((1234, 4567))
    # def solve(self) -> tuple[int, int]:
    #     pass
