import sys
import re
with open (sys.argv[1], 'r') as inputbed :
	for info in inputbed.readlines():
		info_array = info.rstrip('\n').split('\t')
		allele=re.search('(.*)/(.*)',info_array[4])
		geneticDis = float(info_array[9]) - (float(info_array[7]) - float(info_array[2]))*float(info_array[10])/1000000
		print (info_array[3],info_array[0],geneticDis,info_array[2],allele[1],allele[2],sep='\t')

#inputformat: 1	3278	3279	chr1.S_3279	C/T	1	0	1763396	Bin0001	1.175597333	0.666666666
#outputformat: chr1.S_3279	1	0.000109	1763396	C	T
#to get the input format:
#	cat SNPFile|grep -v "rs"|awk '{print $3"\t"$4-1"\t"$4"\t"$1"\t"$2}' > SNP.bed
#	intersectBed -a SNP.bed -b GeneticDistanceBin.bed -wa -wb > inputfile
#GeneticDistanceBin.bed : get from previous study and arranged by Excel
#Format: 10	147354292	147382116	Bin6217	5.714775733(Genetic Distance / Physical Distance)
