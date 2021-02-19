#Rscript used for paired t-Test

Args <- commandArgs()
matrixC = read.table(Args[6],"\t",header = TRUE,row.names = 1)
matrixD = read.table(Args[7],"\t",header = TRUE,row.names = 1)
for (Iname in rownames(matrixC)){
	print ("trait")
	print (Iname)
	input = matrixC[Iname,] - matrixD[Iname,]
	result = t.test(input)
	print(result)
}
