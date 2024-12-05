# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/5

from ...base import StrSplitSolution, answer
from functools import reduce


class Solution(StrSplitSolution):
    _year = 2024
    _day = 5
    _split_on = ""

    @answer((5955, 4030))
    def solve(self) -> int:
        [rules, updates] = reduce(self._split_rules_updates, self.input, [[]])
        self.ruleset = reduce(self._build_ruleset, rules, {})
        updates = list(map(self._process_update, updates))

        (good, bad) = list(reduce(self._find_good_updates, updates, ([], [])))
        part1 = sum(self._get_center(list(update)) for update in good)

        corrected = list(reduce(self._reorder_pages, bad, []))
        part2 = sum(self._get_center(list(update)) for update in corrected)
        return (part1, part2)


    def _get_center(self, pages: list[int]) -> int:
        center = len(pages) // 2
        return pages[center]

    def _process_update(self, update: str) -> list[int]:
        nums = update.split(',')
        return list(map(int, nums))

    def _find_good_updates(self, acc: tuple[list[list[int]], list[list[int]]], pages: list[str]) -> bool:
        seen = set()
        (good, bad) = acc
        for page in pages:
            if page in self.ruleset:
                related = self.ruleset[page]
                for rel in related:
                    if rel in seen:
                        bad.append(pages)
                        return (good, bad)
            seen.add(page)
        good.append(pages)
        return (good, bad)

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

    def _reorder_pages(self, acc: list[list[int]], pages: list[int]) -> list[list[int]]:
        new_order = [pages[0]]
        for page in pages[1:]:
            if page in self.ruleset:
                related = self.ruleset[page]
                indices = [new_order.index(rel) for rel in related if rel in new_order]
                if indices == []:
                    new_order.append(page)
                else:
                    new_order.insert(min(indices), page)
            else:
                new_order.append(page)
        acc.append(new_order)
        return acc

