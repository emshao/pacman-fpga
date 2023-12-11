import numpy as np
import csv

original = ['1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1',
            '1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 1',
            '1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1',
            '1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1',
            '1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1',
            '1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1',
            '1 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1',
            '1 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 1',
            '1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1',
            '1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1',
            '1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1',
            '1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1',
            '1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1',
            '1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1',
            '1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1',
            '1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1',
            '1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1',
            '1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1',
            '1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1',
            '1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1',
            '1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1',
            '1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1']

m = []

# with open("C:\\Users\\Emily Shao\\Desktop\\pacman-fpga\\Memory\\pacman-image.mem", 'rb') as file:
for line in original:
    output = line.split(' ')
    m.append(output)

print(m)

up_pacman = [[m[j][i] for j in range(len(m))] for i in range(len(m[0])-1,-1,-1)]
upside_down_left_pacman = [[up_pacman[j][i] for j in range(len(up_pacman))] for i in range(len(up_pacman[0])-1,-1,-1)]
down_pacman = [[upside_down_left_pacman[j][i] for j in range(len(upside_down_left_pacman))] for i in range(len(upside_down_left_pacman[0])-1,-1,-1)]

left_pacman = [upside_down_left_pacman[len(upside_down_left_pacman)-1-i] for i in range(len(upside_down_left_pacman))]



with open('C:/Users/Emily Shao/Desktop/pacman-fpga/Memory/up_pacman.csv', "w", newline='') as csvFile:
    writer = csv.writer(csvFile)
    for i in up_pacman:
        writer.writerow(i)


with open('C:/Users/Emily Shao/Desktop/pacman-fpga/Memory/down_pacman.csv', "w", newline='') as csvFile:
    writer = csv.writer(csvFile)
    for i in down_pacman:
        writer.writerow(i)

with open('C:/Users/Emily Shao/Desktop/pacman-fpga/Memory/left_pacman.csv', "w", newline='') as csvFile:
    writer = csv.writer(csvFile)
    for i in left_pacman:
        writer.writerow(i)



