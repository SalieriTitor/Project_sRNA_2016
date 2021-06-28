import sys
import re
snpfile = open(sys.argv[1],'r')
header = snpfile.readline()
snpinfo = snpfile.readline()
while (snpinfo):
	snpinfo  = snpinfo.rstrip('\n').split('\t')
	allele = re.search('(.*)/(.*)',snpinfo[1])
	for i in range(11,len(snpinfo)):
		if(i>11):
			print (' ',end='')
		if (snpinfo[i] == allele[1]):
			print ('1 1',end = '')
		elif (snpinfo[i] == allele[2]):
			print ('0 0',end='')
		else :
			print ('9 9',end='')
	print ()
	snpinfo = snpfile.readline()

snpfile.close()

#transform hmpfile to the inputfile of xp-clr file
#a header is needed in hmpfile, although it is not required in transform.
#usage : python script hmpfile >output
