# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/2

from ...base import StrSplitSolution, answer
from collections import deque


class Solution(StrSplitSolution):
    _year = 2024
    _day = 2

    # @answer(1234)
    def part_1(self) -> int:
        levels: list[deque[int]] = []
        for row in self.input:
            levels.append(deque(map(int, row.split())))

        safe_levels = list(filter(lambda row:
                             self.__safe_decreasing(row) or self.__safe_increasing(row),
                             levels))
        return len(safe_levels)


    # @answer(1234)
    def part_2(self) -> int:
        levels: list[deque[int]] = []
        for row in self.input:
            levels.append(deque(map(int, row.split())))

        print(levels)
        safe_levels = list(filter(lambda row:
                             self.__safe_ish_decreasing(row.copy(), []) or self.__safe_ish_increasing(row.copy(), []),
                             levels))
        return len(safe_levels)



    def __safe_ish_decreasing(self, values: deque[int], seen: list[int]) -> bool:
        try:
            a = values.popleft()
            b = values.popleft()
            if b < a and a - b <= 3:
                seen.append(a)
                values.appendleft(b)
                return self.__safe_ish_decreasing(values, seen)
            elif seen == []:
                return self.__safe_decreasing(self.__append_head(values, a)) \
                    or self.__safe_decreasing(self.__append_head(values, b))
            else:
                last = seen.pop()
                return self.__safe_decreasing(self.__append_head(self.__append_head(values, a), last)) \
                    or self.__safe_decreasing(self.__append_head(self.__append_head(values, b), last))

        except IndexError:
            return True

    def __safe_ish_increasing(self, values: deque[int], seen: list[int]) -> bool:
        try:
            a = values.popleft()
            b = values.popleft()
            if b > a and b - a <= 3:
                seen.append(a)
                values.appendleft(b)
                return self.__safe_ish_increasing(values, seen)
            elif seen == []:
                return self.__safe_increasing(self.__append_head(values, a)) \
                    or self.__safe_increasing(self.__append_head(values, b))
            else:
                last = seen.pop()
                return self.__safe_increasing(self.__append_head(self.__append_head(values, a), last)) \
                    or self.__safe_increasing(self.__append_head(self.__append_head(values, b), last))

        except IndexError:
            return True

    def __append_head(self, values: deque[int], head: int) -> deque[int]:
        my_copy = values.copy()
        my_copy.appendleft(head)
        return my_copy

    def __safe_decreasing(self, values: deque[int]) -> bool:
        last = values.popleft()
        for val in values:
            if last <= val:
                return False
            elif last - val > 3:
                return False
            last = val
        return True

    def __safe_increasing(self, values: deque[int]) -> bool:
        last = values.popleft()
        for val in values:
            if last >= val:
                return False
            elif  val - last > 3:
                return False
            last = val
        return True
