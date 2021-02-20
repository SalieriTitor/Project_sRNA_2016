if(!@ARGV){
	print "Usage : perl script inputfile1	inputfile2	inputfile3 \n";
	print "inputfile1 : the result of LDtreatment.pl, used format : cluster199566	C10L58870212	C10L58932364\n";
	print "inputfile2 : the result of eQTLclusterdefine.pl,format : 2	142566637	142582985	5	3.0833e-09	chr2.S_137823202	cluster001080	2	142575950	142575951\n";
	print "inputfile3 : hmpfile for all SNP in allthreholdpoint\n";
	die;
}

mkdir JointEffectunpre || die "couldn't make the outputdir\n";

open(FILE1,$ARGV[0]);
my %list;
while(<FILE1>){
	chomp $_;
	$_ =~ s/\r//;
	@a=split(/\t/,$_);
	if ($a[0] =~/cluster/){
		$key1 = "$a[0]" . "_" ."$a[1]";
		$key2 = "$a[0]" . "_" ."$a[2]";
		$list{"$key1"} = "$key1";
		$list{"$key2"} = "$key2";
	}
}


for $keys(sort keys %list){
	print "$keys\n";
}


open(FILE2,$ARGV[1]);
my %regionchr;
my %regionstart;
my %regionend;
while(<FILE2>){
	chomp;
	@a=split(/\t/);
	$keys = "$a[6]" ."_". "C$a[7]L$a[9]";
	if (defined($list{$keys})){
		$regionchr{$keys}=$a[0];
		$regionstart{$keys}=$a[1];
		$regionend{$keys}=$a[2];
	}
}

for $keys(sort keys %list){
	$echr =  $regionchr{$keys};
	$eend = $regionend{$keys};
	$estart = $regionstart{$keys};
	open(OUT,">JointEffectunpre/$keys");
	open(FILE3,$ARGV[2]);
	$header=<FILE3>;
	chomp $header;
	@temp = split(/\t/,$header);
	for($i=11;$i<@temp;$i++){
		print OUT"\t$temp[$i]";
	}
	print OUT "\n";
	while(<FILE3>){
		chomp;
		@a=split(/\t/,$_);
		my %change;
		if (($a[2] == $echr) && ($a[3] >= $estart) && ($a[3] <= $eend)){
			@allele=split(/\//,$a[1]);
			$change{$allele[0]} = 0;
			$change{$allele[1]} = 1;
			$change{"N"} = "NA";
			print OUT "$a[0]";
			for($i=11;$i<@a;$i++){
				print OUT "\t$change{$a[$i]}";
			}
			print OUT "\n";
		}
	}
}
