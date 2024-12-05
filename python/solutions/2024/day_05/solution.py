# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/5

from ...base import StrSplitSolution, answer
from functools import reduce


class Solution(StrSplitSolution):
    _year = 2024
    _day = 5
    _split_on = ""

    # @answer(1234)
    def part_1(self) -> int:
        [rules, updates] = reduce(self._split_rules_updates, self.input, [[]])
        self.ruleset = reduce(self._build_ruleset, rules, {})
        updates = list(map(self._process_update, updates))

        good_updates = list(filter(self._find_good_updates, updates))
        return sum(self._get_center(list(update)) for update in good_updates)

    # @answer(1234)
    def part_2(self) -> int:
        pass

    def _get_center(self, pages: list[int]) -> int:
        center = len(pages) // 2
        return pages[center]

    def _process_update(self, update: str) -> list[int]:
        nums = update.split(',')
        return list(map(int, nums))

    def _find_good_updates(self, pages: list[str]) -> bool:
        seen = set()
        for page in pages:
            if page in self.ruleset:
                related = self.ruleset[page]
                for rel in related:
                    if rel in seen:
                        return False
            seen.add(page)
        return True

    def _build_ruleset(self, acc: dict, line: str) -> dict:
        [key, val] = list(map(int, line.split("|")))
        if key in acc:
            current_val = acc[key]
            current_val.append(val)
            return acc
        else:
            return acc | {key: [val]}

    def _split_rules_updates(self, acc: list[list[str]], val: str) -> list[list[str]]:
        if val == self._split_on:
            acc.append([])
        else:
            acc[-1].append(val)
        return acc
