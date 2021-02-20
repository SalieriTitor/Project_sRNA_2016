# Project_sRNA_2016
#The scripts used in project
for sRNA processing :
 
  Low_Quality_filter.pl was used to remove the sRNA reads with low quality.
  PolyA_trim.pl was used to remove the polyA/T reads.

for DR sRNA identification:
 
  Paired-T-test.R was used to perform paired-t-test.
  eMatrix2biomarker.pl and Biomarker2hmp were used to construct hmpfiles for sRNA expression.
  transposition_matrix.pl was used to transpose expression matrix.
  
for sRNA-gene correlation:
  
  correlation_coefficient.pl was used to calculate (R was needed) the correlation coefficient.

for eQTL identification:

  candidate_eQTL_find.pl was used to identify the candidate eQTLs.
  SNPs_used_for_JE_calculation.pl was used to arrange the format of SNPs used to calculate the joint effect.
  LD_treatment.pl was used to filt the candidate eQTL throuth LD and p-value.
  arrange_joint_effect.pl was used to arrange the joint effect result of candidate eQTL.
  major_eQTL.pl was used to get the major eQTL infomation.
  
for IR identification:

   SplitGenome.pl was used to split genome into given length. These splited reads will be further blast to itself by blastn.
   Treat_blastn_output.pl was used to arrange the output of blast for further analyse.
   IRfinder.pl  was used to identify the IR region and give the IR ratio.
   
for figure drawing:
  
  Maize_V4_eQTL_map_drawing2.pl was used to draw figure 2a
  LD_figure.pl was used to draw figure 2c
  mhtplot.pl was used to draw Manhattan plots in figure S3
  Maize_V4_eQTL_map_drawing.pl was used to draw figure S4a

Because of the different system configuration, these custom scripts may not word well sometimes. Meanwhile, some modules of perl must be intalled in advance. If there is any questions, please contact 806289014@qq.com
