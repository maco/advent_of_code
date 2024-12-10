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
        summits = []
        paths = 0
        for row in range(self.height):
            for col in range(self.width):
                if self.topography[row][col] == 0:
                    found_summits, found_paths = self._find_summits(row, col, set(), 0)
                    summits.extend(found_summits)
                    paths += found_paths

        return (len(summits), paths)

    def _find_summits(
        self, row: int, col: int, summits: set[tuple[int, int]], paths: int
    ) -> tuple[set[tuple[int, int]], int]:
        if self.topography[row][col] == 9:
            summits.add((row, col))
            paths += 1
            return (summits, paths)

        for next_row, next_col in self._list_neighbors(row, col):
            if self.topography[next_row][next_col] - self.topography[row][col] == 1:
                (summits, paths) = self._find_summits(
                    next_row, next_col, summits, paths
                )
        return (summits, paths)

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
