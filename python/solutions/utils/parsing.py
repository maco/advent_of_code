# add whatever utilities you'll find useful across multiple solutions
# import them in a solution using:
# from ...utils.example import add


def parse_column_ints(input: list[str]):
    columns: list[int] = []

    for line_num, line in enumerate(input):
        fields = line.split()
        for index, field in enumerate(fields):
            if line_num == 0:
                columns.append([int(field)])
            else:
                columns[index].append(int(field))
    return columns
