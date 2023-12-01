import csv

data = []

with open("C:\\Users\\Emily Shao\\Desktop\\lab6_kit\\CSV_Files\\boolean-pacman-mod.csv", "r", newline='') as file:
    for line in file:
        data.append(line.split(','))

# print(len(data))
# print(len(data[0]))
# # print(data[0])

# print(data[3])

for x in range(len(data)):
    for y in range(len(data[0])):
        if (data[x][y] != 'C'):
            data[x][y] = '0'

for x in range(len(data)):
    for y in range(len(data[0])):
        if (data[x][y] == 'C'):
            data[x][y] = '1'

with open("C:\\Users\\Emily Shao\\Desktop\\lab6_kit\\CSV_Files\\boolean-pacman-mod-2.csv", "w", newline='') as file:
    writer = csv.writer(file)
    for x in data:
        writer.writerow(x)