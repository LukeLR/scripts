import sys
line = sys.stdin.readline()
print("read: {}".format(line))
size,path = line.split(maxsplit=1)
while(True):
	nextline = sys.stdin.readline()
	print("read: {}".format(nextline))
	nextsize,nextpath = nextline.split(maxsplit=1)
	if (size == nextsize):
		print("{} {}".format(size, path))
	while (size == nextsize):
		print("{} {}".format(nextsize, nextpath))
		nextline = sys.stdin.readline()
		print("read: {}".format(nextline))
		nextsize,nextpath = nextline.split(maxsplit=1)
	size=nextsize
	path=nextpath
