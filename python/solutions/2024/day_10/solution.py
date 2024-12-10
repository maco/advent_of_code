# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/10

from ...base import StrSplitSolution, answer


class Solution(StrSplitSolution):
    _year = 2024
    _day = 10

    @answer(820)
    def part_1(self) -> int:
        self.topography = [[int(char) for char in line] for line in self.input]
        self.width = len(self.topography[0])
        self.height = len(self.topography)
        summits = []
        for row in range(self.height):
            for col in range(self.width):
                if self.topography[row][col] == 0:
                    summits.extend(self._find_summits(row, col, set()))
        return len(summits)

    # @answer(1234)
    def part_2(self) -> int:
        pass

    def _find_summits(
        self, row: int, col: int, acc: set[tuple[int, int]]
    ) -> list[tuple[int, int]]:
        if self.topography[row][col] == 9:
            acc.add((row, col))
            return acc

        for next_row, next_col in self._list_neighbors(row, col):
            if self.topography[next_row][next_col] - self.topography[row][col] == 1:
                acc = self._find_summits(next_row, next_col, acc)
        return acc

    def _list_neighbors(self, row, col):
        neighbors = []
        if row > 0:
            neighbors.append((row - 1, col))
        if row < self.height - 1:
            neighbors.append((row + 1, col))
        if col > 0:
            neighbors.append((row, col - 1))
        if col < self.width - 1:
            neighbors.append((row, col + 1))
        return neighbors

    # @answer((1234, 4567))
    # def solve(self) -> tuple[int, int]:
    #     pass
