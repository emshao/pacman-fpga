import csv

# testing script

data = []

# change file path 
with open("CSV\\test-change-pixel.csv", "r", newline='') as file:
    for line in file:
        data.append(line.split(','))

print(len(data))
print(len(data[0]))

print(data)

for x in range(len(data)-3):
    for y in range(len(data[0])-3):
        
        if (data[x][y] == '0') or (data[x][y] == '0\r\n'):
            print("here", x, y, data[x][y])
            change = True
            for i in range(3):
                for j in range(3):
                    print(data[x+i][y+j])
                    if (data[x+i][y+j] not in ['0', '0\r\n']):
                        change = False
            
            if change:
                print("here")
                data[x][y] = 'C'

# change file path
with open("CSV\\test-change-mod.csv", "w", newline='') as file:
    writer = csv.writer(file)
    for x in data:
        writer.writerow(x)
