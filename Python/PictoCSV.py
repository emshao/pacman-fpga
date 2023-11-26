# Use image processing package
import os
import csv
import sys

try:
    from PIL import Image
except:
    response = input("This script requires the image processing package, Pillow. \nWould you like to download it? (y/n) ")
    if(response.strip() == "y"):
        os.system("pip3 install pillow")
    else:
        sys.exit()
        
if len(sys.argv) != 3:
    print("Usage: PictoCSV.py ImageName SaveFileName")
    sys.exit()

imageName = sys.argv[1]
saveName = sys.argv[2]

# change to local paths
image_path = "Pictures\\"
csv_path = "CSV\\"

file = Image.open(image_path + imageName)

img = file.quantize(256)
pixels = img.load()
pal = [color >> 4 for color in img.getpalette()]
colors = [pal[3*n:3*(n+1)] for n in range(int(len(pal)/3))]
with open(csv_path + saveName + "-colors.csv", "w") as csvFile:
    writer = csv.writer(csvFile)
    for n in range(int(len(colors)/8)):
        writer.writerow([(hex(color[0])[2:] + hex(color[1])[2:] + hex(color[1])[2:]) for color in colors[8 * n:8 * (n + 1)]])

with open(csv_path + saveName + "-image.csv", "w") as csvFile:
    writer = csv.writer(csvFile)
    for y in range(img.size[1]):
        toWrite = []
        for x in range(img.size[0]):
            toWrite.append(hex(pixels[x, y])[2:])
        writer.writerow(toWrite)

