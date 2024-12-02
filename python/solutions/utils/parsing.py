def parse_column_ints(input: list[str]):
    result = []
    for row_num, row in enumerate(input):
        values = map(int, row.split())
        for col_num, val in enumerate(values):
            if row_num == 0:
                result.append([val])
            else:
                result[col_num].append(val)
    return result
