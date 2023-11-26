import csv
import sys

# change path to be local
csv_path = "CSV\\"
mem_path = "Memory\\"

if len(sys.argv) != 2:
    print("Usage: CSVtoMem.py csvName")
    sys.exit()

imageName = sys.argv[1]

with open(csv_path + imageName + "-colors.csv", "r") as csvFile:
       with open(mem_path + imageName + "-colors.mem", "w") as memFile:
            for row in csv.reader(csvFile):
                memFile.write(" ".join(row) + "\n")

with open(csv_path + imageName + "-image.csv", "r") as csvFile:
    with open(mem_path + imageName + "-image.mem", "w") as memFile:
        for row in csv.reader(csvFile):
            memFile.write(" ".join(row) + "\n")