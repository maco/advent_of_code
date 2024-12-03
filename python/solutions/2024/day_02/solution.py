# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/2

from ...base import StrSplitSolution, answer
from collections import deque
from collections.abc import Callable
import operator


class Solution(StrSplitSolution):
    _year = 2024
    _day = 2

    @answer(637)
    def part_1(self) -> int:
        levels: list[deque[int]] = []
        for row in self.input:
            levels.append(deque(map(int, row.split())))

        safe_levels = list(
            filter(
                lambda row: self.__safe_changing(row, operator.lt)
                or self.__safe_changing(row, operator.gt),
                levels,
            )
        )
        return len(safe_levels)

    @answer(665)
    def part_2(self) -> int:
        levels: list[deque[int]] = []
        for row in self.input:
            levels.append(deque(map(int, row.split())))

        safe_levels = list(
            filter(
                lambda row:
                self.__safe_ish_changing(row.copy(), [], operator.gt)
                or self.__safe_ish_changing(row.copy(), [], operator.lt),
                levels,
            )
        )
        return len(safe_levels)

    def __safe_changing(self, values: deque[int], op: Callable) -> bool:
        last = values.popleft()
        for val in values:
            if not (op(last, val) and abs(last - val) <= 3):
                return False
            last = val
        return True

    def __safe_ish_changing(
        self, values: deque[int], seen: list[int], op: Callable
    ) -> bool:
        try:
            a = values.popleft()
            b = values.popleft()
            if op(a, b) and abs(a - b) <= 3:
                seen.append(a)
                values.appendleft(b)
                return self.__safe_ish_changing(values, seen, op)
            elif seen == []:
                return self.__safe_changing(
                    self.__append_head(values, a), op
                ) or self.__safe_changing(self.__append_head(values, b), op)
            else:
                last = seen.pop()
                return self.__safe_changing(
                    self.__append_head(self.__append_head(values, a), last), op
                ) or self.__safe_changing(
                    self.__append_head(self.__append_head(values, b), last), op
                )

        except IndexError:
            return True

    def __append_head(self, values: deque[int], head: int) -> deque[int]:
        my_copy = values.copy()
        my_copy.appendleft(head)
        return my_copy
