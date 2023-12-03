import csv
import numpy as np

bigList = []

with open('boolean-map.csv', newline='') as csvfile:
    bMapAll = csv.reader(csvfile, delimiter=',', quotechar='|')
    for row in bMapAll:
        for elem in row:
            bigList.append(int(elem))

bigList = np.array(bigList)


encode = []

index = 1
count = 1
while(index < len(bigList)):
    testBool = False
    while((index < len(bigList)) and (bigList[index] == bigList[index - 1])):
        count += 1
        index += 1
        testBool = True

    encode.append(count)
    encode.append(bigList[index - 1])
    count = 1
    if(not testBool):
        index += 1

newEnc = []
newVals = []
for i in range(len(encode)):
    if(i%4 == 0):
        newEnc.append(encode[i])
    elif(i%4 == 1):
        newVals.append(encode[i])

with open('encoded-bools.csv', 'w', newline='') as csvfile:
    writee = csv.writer(csvfile, delimiter=',',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    for i in range(len(encode)):
        writee.writerow([encode[i]])

with open('encoded-bools-real.csv', 'w', newline='') as csvfile:
    writee = csv.writer(csvfile, delimiter=',',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    for i in range(len(newEnc)):
        writee.writerow([newEnc[i]])


with open('commands.txt', 'w') as f:
    count = 0
    for i in range(len(newVals)):
        newPosI = count//640
        newPosJ = count % 640

    f.write('readme')


reconstruct = []
for i in range(len(newVals)):
    count = 0
    while(count < newEnc[i]):
        reconstruct.append(newVals[i])
        count += 1


areSame = True
for i in range(len(reconstruct)):
    if(reconstruct[i] != bigList[i]):
        areSame = False

if(areSame):
    print("success :)")




