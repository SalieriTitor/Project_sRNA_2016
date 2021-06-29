import sys
import numpy as np
listinfo = {}
with open(sys.argv[1], mode='r') as needList:
	for data in needList.readlines():
		data = data.rstrip('\n')
		listinfo[data] = data
		#print (data)

snpfile = open(sys.argv[2],mode='r')
snpheader = snpfile.readline().rstrip('\r\n').split('\t')
print (*snpheader[0:11],sep='\t',end='')
needprint={}
for num in range(11,len(snpheader)):
	if (snpheader[num] in listinfo.keys()):
		print ('\t',snpheader[num],sep='',end='')
		needprint[num] = num
print ()
snpinfo = snpfile.readline()
while(snpinfo):
	snps = snpinfo.rstrip('\r\n').split('\t')
	print (*snps[0:11],sep='\t',end='')
	for num in range(11,len(snps)):
		if (num in needprint.keys()):
			print ('\t',snps[num],sep='',end='')
	print ()
	snpinfo = snpfile.readline()
snpfile.close()

#usage : python script list hmpfile >output
#the list file, just have the inbred name, 1column
