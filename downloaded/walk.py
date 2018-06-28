import os
import re
#regex = '[^a-zA-Z0-9\_\-\.]
for root, dirs, files in os.walk('/mnt/filme/5TB-HDD/Filmbank-hfsprescue'):
	#print("root {} has files {} and dirs {}".format(root, dirs, files))
	print("in directory {}:".format(root))
	for afile in files:
		print("file {} maps to {}".format(afile, afile.encode('ascii', 'namereplace')))
