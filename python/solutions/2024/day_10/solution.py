# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/10

from ...base import StrSplitSolution, answer


class Solution(StrSplitSolution):
    _year = 2024
    _day = 10

    @answer((820, 1786))
    def solve(self) -> tuple[int, int]:
        self.topography = [[int(char) for char in line] for line in self.input]
        self.width = len(self.topography[0])
        self.height = len(self.topography)
        self.paths = 0
        summits = []
        for row in range(self.height):
            for col in range(self.width):
                if self.topography[row][col] == 0:
                    found_summits = set()
                    self._find_summits(row, col, found_summits)
                    summits.extend(found_summits)

        return (len(summits), self.paths)

    def _find_summits(self, row: int, col: int, summits: set[tuple[int, int]]) -> None:
        if self.topography[row][col] == 9:
            summits.add((row, col))
            self.paths += 1
        else:
            for next_row, next_col in self._list_neighbors(row, col):
                if self.topography[next_row][next_col] - self.topography[row][col] == 1:
                    self._find_summits(next_row, next_col, summits)

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
