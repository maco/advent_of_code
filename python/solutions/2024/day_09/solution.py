# Generated using @xavdid's AoC Python Template: https://github.com/xavdid/advent-of-code-python-template

# puzzle prompt: https://adventofcode.com/2024/day/9

from ...base import TextSolution, answer


class Solution(TextSolution):
    _year = 2024
    _day = 9

    @answer(6279058075753)
    def part_1(self) -> int:
        self._fill_disk(self.input)

        left_pointer = 0
        right_pointer = (
            len(self.disk) - 1 if self.disk[-1] is not None else len(self.disk) - 2
        )

        while left_pointer < right_pointer:
            if self.disk[left_pointer] is None and self.disk[right_pointer] is not None:
                self._move_block(left_pointer, right_pointer)
                right_pointer -= 1
                left_pointer += 1
            elif self.disk[left_pointer] is not None:
                left_pointer += 1
            else:
                right_pointer -= 1

        return self._checksum()

    @answer(6301361958738)
    def part_2(self) -> int:
        self._fill_disk(self.input)

        right_pointer = (
            len(self.disk) - 1 if self.disk[-1] is not None else len(self.disk) - 2
        )

        file_id = self.disk[right_pointer]

        while right_pointer > 0:
            if self.disk[right_pointer] is not None:
                file_id = self.disk[right_pointer]
                file_size = self._size_of_file(right_pointer, file_id)
                move_to = self._find_empty(file_size, right_pointer - file_size)
                if move_to is None:
                    right_pointer -= file_size
                    continue
                self._move_file(move_to, right_pointer, file_size)
                # if right is on a file
                # pop left_pointer to start and walk across in search of empty space
                # calculate size of empty space and size of file
                # if empty >= file, move file
                # (fill file_size spaces of empty, then set file spaces to none)
                right_pointer -= 1
            else:
                right_pointer -= 1

        return self._checksum()

    def _move_file(self, empty_index, file_index, size):
        val = self.disk[file_index]
        for i in range(size):
            self.disk[empty_index + i] = val
            self.disk[file_index - i] = None

    def _find_empty(self, needed: int, before: int) -> int | None:
        start_at = 0
        try:
            while start_at < before:
                first_empty = self.disk.index(None, start_at, before)
                size = self._size_of_empty(first_empty)
                if size >= needed:
                    return first_empty
                start_at = first_empty + size
        except ValueError:
            return None
        return None

    def _size_of_empty(self, left_index):
        count = 1
        while self.disk[left_index + count] is None:
            count += 1
        return count

    def _size_of_file(self, right_index: int, value: int):
        count = 1
        while self.disk[right_index - count] == value:
            count += 1
        return count

    def _fill_disk(self, data):
        compacted = list(data)
        self.disk = []

        for index, char in enumerate(compacted):
            block_len = int(char)

            if index % 2 == 0:
                for _i in range(block_len):
                    self.disk.append(index // 2)
            else:
                for _i in range(block_len):
                    self.disk.append(None)

    def _move_block(self, left_index, right_index):
        self.disk[left_index] = self.disk[right_index]
        self.disk[right_index] = None

    def _checksum(self):
        total = 0
        for idx, num in enumerate(self.disk):
            if num is None:
                continue
            total += idx * num
        return total
