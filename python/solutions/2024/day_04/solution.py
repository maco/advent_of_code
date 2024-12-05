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
        xmases = 0
        # sum(self.count_xmases(grid, row, col) for row in range(0, len(grid)) for col in range(0, width) if grid[row, col] == 'X' )

        for row in range(0, len(grid)):
            for col in range(0, width):
                if grid[row][col] == 'X':
                    xmases += self.count_xmases(grid, row, col)
        return xmases

    @answer(1945)
    def part_2(self) -> int:
        grid = [list(line) for line in self.input]
        width = len(grid[0])
        mases = 0
        front_slash = [(operator.add, operator.sub), (operator.sub, operator.add)]
        back_slash = [(operator.add, operator.add), (operator.sub, operator.sub)]

        for row in range(1, len(grid) - 1):
            for col in range(1, width - 1):
                if grid[row][col] == 'A':
                    mases += 1 if self._check_corners(grid, row, col, front_slash) and self._check_corners(grid, row, col, back_slash) else 0
        return mases

    def _check_corners(self, grid, row, col, ops):
        [(op1, op2), (op3, op4)] = ops
        letters = {grid[op1(row, 1)][op2(col, 1)], grid[op3(row, 1)][op4(col, 1)]}
        print(f"{row}, {col}: {letters}")
        return letters in [{'M', 'S'}, {'S', 'M'}]

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
