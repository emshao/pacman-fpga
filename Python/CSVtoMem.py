import csv
import sys

# change path to be local
csv_path = "C:\\Users\\Emily Shao\\Desktop\\pacman-fpga\\CSV\\"
mem_path = "C:\\Users\\Emily Shao\\Desktop\\pacman-fpga\\Memory\\"

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

# with open(imageName, "r") as csvFile:
#     with open(mem_path + "ghost-image.mem", "w") as memFile:
#         for row in csv.reader(csvFile):
#             memFile.write(" ".join(row) + "\n")