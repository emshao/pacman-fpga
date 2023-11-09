import csv
path = ""

with open(path + "C:\\Users\\Emily Shao\\Box\\on desktop transfer\\lab6-7_kit\\lab6_kit\\colors.csv", "r") as csvFile:
       with open(path + "C:\\Users\\Emily Shao\\Box\\on desktop transfer\\lab6-7_kit\\lab6_kit\\colorsMine.mem", "w") as memFile:
            for row in csv.reader(csvFile):
                memFile.write(" ".join(row) + "\n")

with open(path + "C:\\Users\\Emily Shao\\Box\\on desktop transfer\\lab6-7_kit\\lab6_kit\\image.csv", "r") as csvFile:
    with open(path + "C:\\Users\\Emily Shao\\Box\\on desktop transfer\\lab6-7_kit\\lab6_kit\\imageMine.mem", "w") as memFile:
        for row in csv.reader(csvFile):
            memFile.write(" ".join(row) + "\n")
