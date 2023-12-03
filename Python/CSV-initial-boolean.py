import csv

data = []

# change file path
with open("CSV\\boolean-pacman.csv", "r", newline='') as file:
    for line in file:
        data.append(line.split(','))

print(len(data))
print(len(data[0]))

for x in range(len(data)):
    data[x][len(data[0])-1] = data[x][len(data[0])-1].strip()

for x in range(len(data)-21):
    for y in range(len(data[0])-21):
        data[x][y] = data[x][y].strip()

        if (data[x][y] == '0'):
            change = True

            for i in range(22):
                for j in range(22):
                    if (data[x+i][y+j] not in ['0', '0\r\n']):
                        change = False
            
            if change:
                data[x][y] = 'C'

print("done changing")


# change file path
with open("CSV\\boolean-pacman-mod.csv", "w", newline='') as file:
    writer = csv.writer(file)
    counter = 0
    for x in data:
        counter += 1
        writer.writerow(x)
    
    print(counter)