# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/4

from ...base import StrSplitSolution, answer
import operator


class Solution(StrSplitSolution):
    _year = 2024
    _day = 4

    @answer(2458)
    def part_1(self) -> int:
        grid = [list(line) for line in self.input]
        width = len(grid[0])

        # diag_mas = self.check_xmas(grid, 0, 4, (operator.add, operator.add))
        # straight_mas = self.check_xmas(grid, 0, 5, (self._identity, operator.add))
        # corner = self.count_xmases(grid, 9, 9)
        # num = self.count_xmases(grid, 9, 1)
        xmases = 0
        # sum(self.count_xmases(grid, row, col) for row in range(0, len(grid)) for col in range(0, width) if grid[row, col] == 'X' )

        for row in range(0, len(grid)):
            for col in range(0, width):
                if grid[row][col] == 'X':
                    xmases += self.count_xmases(grid, row, col)
        return xmases

    # @answer(1234)
    def part_2(self) -> int:
        pass

    def count_xmases(self, grid, row, col):
        directions = [
            (operator.add, operator.add),
            (operator.add, operator.sub),
            (operator.sub, operator.add),
            (operator.sub, operator.sub),
            (operator.add, self._identity),
            (operator.sub, self._identity),
            (self._identity, operator.add),
            (self._identity, operator.sub),
            ]
        return len(list(filter(lambda direction: self.check_xmas(grid, row, col, direction), directions)))

    def check_xmas(self, grid, row, col, ops):
        try:
            (row_op, col_op) = ops
            maybe_mas = [grid[self._no_negative(row_op(row, offset))][self._no_negative(col_op(col, offset))] for offset in range(1,4)]
            if maybe_mas == ['M', 'A', 'S']:
                return True
        except IndexError:
            return False

    def _identity(self, val, _offset):
        return val

    def _no_negative(self, val):
        if val < 0:
            raise IndexError
        return val

    def _print_debug(self, val):
        print(val)
        return val
