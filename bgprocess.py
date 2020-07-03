
fin = open("farmland.bin", "r")
fout = open("farmland.out", "w")

for z in range(0,2):
    for y in range(0,25):
        readpos = z*6*25*40
        readpos += y*40
        for x in range(0,6):
            fin.seek(readpos)
            print('reading 40 bytes from position {}'.format(readpos))
            bytes = fin.read(40)
            fout.write(bytes)
            readpos += 1000

fin.close()
fout.close()
