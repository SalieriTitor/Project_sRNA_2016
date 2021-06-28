#-*- coding: UTF-8 -*-
import sys
import re
from scipy import stats
import numpy as np

snp =  open(sys.argv[1], mode='r')
phe =  open(sys.argv[2], mode='r')
callist = open(sys.argv[3], mode='r')

snpheader = snp.readline()
snpheader_info = snpheader.rstrip('\n').split('\t')
snpheader_info = snpheader_info[11:]
snpinfos = {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
allele1 = {}
allele2 = {}
genotype= {}
#print(snpheader_info[1])      
snpinfo = snp.readline()
while(snpinfo):
	snpinfo = snpinfo.rstrip('\n').split('\t')
	snpinfos[snpinfo[0]] = snpinfo[11:]
	#allele[snpinfo[0]] = snpinfo[1]
	result=re.search('(.*)/(.*)',snpinfo[1])
	#print (result[1])
	#print (result[2])
	allele1[snpinfo[0]] = result[1]
	allele2[snpinfo[0]] = result[2]
	listlen = len(snpinfos[snpinfo[0]])
	#print (allele2[snpinfo[0]])
	#print (allele[snpinfo[0]])
	#print (snpinfos[snpinfo[0]])
	#print (listlen)
	snpid = snpinfo[0]
	genotype[snpid] = {}
	for num in range(listlen):
		#print(snpheader_info[num])
		inbred = snpheader_info[num]
		genotype[snpid][inbred] = snpinfo[num+11]           
		#print (snpid,inbred,'\t',genotype[snpid][inbred])
	snpinfo = snp.readline()
snp.close()
###get the phenotype file###
phenotypeHeader = phe.readline()
phenotypeHeader = phenotypeHeader.rstrip('\n').split('\t')
phenotypeHeader = phenotypeHeader[1:]
inbred_phe_pri = {}
inbred_phe={}
phenotype = phe.readline()
while(phenotype):
	phenotype = phenotype.rstrip('\n').split('\t')
	#print (phenotype[1:])
	inbred_phe_pri[phenotype[0]] = phenotype[1:]
	listlen = len(inbred_phe_pri[phenotype[0]])
	#print (phenotype[0])
	inbred_phe[phenotype[0]] = {}
	for num in range(0,listlen):                                  
		inbred_phe[phenotype[0]][phenotypeHeader[num]] = inbred_phe_pri[phenotype[0]][num]
		#print (phenotypeHeader[num],inbred_phe[phenotype[0]][phenotypeHeader[num]])
	phenotype = phe.readline()
phe.close()
############################
callist_info = callist.readline()
while(callist_info):
	callist_info = callist_info.rstrip('\n').split('\t')
	if ((callist_info[0] in snpinfos.keys()) and (callist_info[1] in inbred_phe_pri.keys())):
		gtype1 = allele1[callist_info[0]]
		gtype2 = allele2[callist_info[0]]
		phe_gtype1 =[]
		phe_gtype2 =[]

		for i in genotype[callist_info[0]].keys() :

			#print (i) # all inbred in SNP file.
			if(genotype[callist_info[0]][i] == gtype1):
				if(i in inbred_phe[callist_info[1]].keys()):
					#print (i) # all gt1 inbred in phenotype file.
					if(inbred_phe[callist_info[1]][i] != ''):
						#print(inbred_phe[callist_info[1]][i])
						phe_gtype1.append(inbred_phe[callist_info[1]][i])
			if(genotype[callist_info[0]][i] == gtype2):
				if(i in inbred_phe[callist_info[1]].keys()):
					#print (i)
					if(inbred_phe[callist_info[1]][i] != ''):
						#print(inbred_phe[callist_info[1]][i])
						phe_gtype2.append(inbred_phe[callist_info[1]][i])
		if ((len(phe_gtype1)) >0 and (len(phe_gtype2)>0)):
			phe_gtype1 = list(map(float, phe_gtype1))
			phe_gtype2 = list(map(float, phe_gtype2))
			result = stats.ttest_ind(phe_gtype1,phe_gtype2,equal_var = False)
			print (callist_info[0],callist_info[1],gtype1,len(phe_gtype1),np.mean(phe_gtype1),gtype2,len(phe_gtype2),np.mean(phe_gtype2),result[1],sep='\t')
	callist_info = callist.readline()
callist.close()


##Usage : python genotypeCal.py input1(snp hmp file,argv1) input2(phenotype file,phenotype matrix, argv2) input3(list,2 column, 1st as snpid, 2nd as phenotype name)
#output : snpid	phenotypename	genotype1	number_of_genotype1	average_genotype1	genotype2	number_of_genotype2	average_genotype2	pvalue
