def count_identical_lines(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        lines1 = set(f1.readlines())
        lines2 = set(f2.readlines())

        identical_lines = lines1 & lines2
        return len(lines1), len(identical_lines)


file1 = "rezultat (1).csv"
file2 = "output (15).csv"
total_lines, identical_line_count = count_identical_lines(file1, file2)
print(f"Numarul de linii identice intre {file1} si {file2} este: {identical_line_count}")
print(f"Acuratete: {identical_line_count / total_lines * 100:.2f}%")

# 
