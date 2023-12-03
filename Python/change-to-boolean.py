import csv

data = []

# change file path
with open("CSV\\boolean-pacman-mod.csv", "r", newline='') as file:
    for line in file:
        data.append(line.split(','))

for x in range(len(data)):
    for y in range(len(data[0])):
        if (data[x][y] != 'C'):
            data[x][y] = '0'

for x in range(len(data)):
    for y in range(len(data[0])):
        if (data[x][y] == 'C'):
            data[x][y] = '1'


# change file path
with open("CSV\\boolean-pacman-mod-2.csv", "w", newline='') as file:
    writer = csv.writer(file)
    for x in data:
        writer.writerow(x)