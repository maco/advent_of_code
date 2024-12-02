# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/2

from ...base import StrSplitSolution, answer
from collections import deque
from collections.abc import Callable


class Solution(StrSplitSolution):
    _year = 2024
    _day = 2

    @answer(637)
    def part_1(self) -> int:
        levels: list[deque[int]] = []
        for row in self.input:
            levels.append(deque(map(int, row.split())))

        safe_levels = list(filter(lambda row:
                             self.__safe_changing(row, self.__safe_decrease) or self.__safe_changing(row, self.__safe_increase),
                             levels))
        return len(safe_levels)

    @answer(665)
    def part_2(self) -> int:
        levels: list[deque[int]] = []
        for row in self.input:
            levels.append(deque(map(int, row.split())))

        safe_levels = list(filter(lambda row:
                             self.__safe_ish_changing(row.copy(), [], self.__safe_decrease) or self.__safe_ish_changing(row.copy(), [], self.__safe_increase),
                             levels))
        return len(safe_levels)

    def __safe_changing(self, values: deque[int], comparator: Callable) -> bool:
        last = values.popleft()
        for val in values:
            if not comparator(last, val):
                return False
            last = val
        return True

    def __safe_ish_changing(self, values: deque[int], seen: list[int], comparator: Callable) -> bool:
        try:
            a = values.popleft()
            b = values.popleft()
            if comparator(a, b):
                seen.append(a)
                values.appendleft(b)
                return self.__safe_ish_changing(values, seen, comparator)
            elif seen == []:
                return self.__safe_changing(self.__append_head(values, a), comparator) \
                    or self.__safe_changing(self.__append_head(values, b), comparator)
            else:
                last = seen.pop()
                return self.__safe_changing(self.__append_head(self.__append_head(values, a), last), comparator) \
                    or self.__safe_changing(self.__append_head(self.__append_head(values, b), last), comparator)

        except IndexError:
            return True

    def __append_head(self, values: deque[int], head: int) -> deque[int]:
        my_copy = values.copy()
        my_copy.appendleft(head)
        return my_copy

    def __safe_increase(self, val1: int, val2: int) -> bool:
        return val1 < val2 and val2 - val1 <= 3

    def __safe_decrease(self, val1: int, val2: int) -> bool:
        return val1 > val2 and val1 - val2 <= 3
