#Transform biomarker to hmp file
if(!@ARGV){
	print "Usage : perl script namelist INPUT type >OUTPUT\n";
	print "to transform the biomarker to hmpformat to do the GWAS\n";
	print "type1 : change 0 To A, 1 To T, 3 To N(default).\n";
	print "type2 : change 0 To A, 1 To T, 3 To A.\n";
	print "type3 : change 0 To A, 1 To T, 3 To T.\n";
	die;
}
open(NAME,$ARGV[0]);
@file = split(/\//,$ARGV[1]);
$arv= @file - 1;
$filename=$file[$arv];
if($ARGV[2] == 1){
	$type = 1;
}elsif($ARGV[2] == 2){
	$type = 2;
}elsif($ARGV[2] ==3){
	$type = 3;
}else{
	$type = 1;
}
while(<NAME>){
	chomp;
	@a=split(/\t/);
	$hash{$a[0]} = $a[1];
}
open(BIOMARKER,$ARGV[1]);
$header=<BIOMARKER>;
chomp $header;
@a=split(/\t/,$header);
print "rs#	alleles	chrom	pos	strand	assembly#	center	protLSID	assayLSID	panelLSID	QCcodes";
for ($i=1;$i<@a;$i++){
	print "\t$hash{$a[$i]}";
}
print "\n";
my $n=1;
while(<BIOMARKER>){
	chomp;
	@a=split(/\t/);
	print "chr1.S_$n	A/T	1	$n	+	NA	NA	NA	NA	NA	NA";
	$marker{$n} = $a[0];
	$n++;
	for ($i=1;$i<@a;$i++){
		if($type==1){
			if($a[$i] == 0){
				print "\tA";
			}
			if($a[$i] == 1){
				print "\tT";
			}
			if($a[$i] == 3){
				print "\tN";
			}
		}
		if($type==2){
			if($a[$i] == 0){
				print "\tA";
			}
			if($a[$i] == 1){
				print "\tT";
			}
			if($a[$i] == 3){
				print "\tA";
			}
		}
		if($type==3){
			if($a[$i] == 0){
				print "\tA";
			}
			if($a[$i] == 1){
				print "\tT";
			}
			if($a[$i] == 3){
				print "\tT";
			}
		}
	}
	print "\n";
}

open(OUTMARKER,">${filename}type$type");
for $keys(sort{$a<=>$b} keys %marker){
	print OUTMARKER "$keys\t$marker{$keys}\n";
}
