#calculate the correlation coefficient

use Statistics::R;
if(!@ARGV){
	print "Usage : perl script input pairneedcalculate expMatrix1 expMatrix2 >output\n";
	die;
}

open(EXP1,$ARGV[1]);
open(EXP2,$ARGV[2]);
$header1 = <EXP1>;
while(<EXP1>){
	chomp;
	@a=split(/\t/,$_,2);
	$exp1{$a[0]} = $a[1];
}
$header2 = <EXP2>;
while(<EXP2>){
	chomp;
	@a=split(/\t/,$_,2);
	$exp2{$a[0]} = $a[1];
}

open(LIST,$ARGV[0]);
while(<LIST>){
	chomp;
	@temp = split(/\t/);
	@a="";
	$out ="";
	my $R =Statistics::R -> new();
	$k1 = $temp[0];
	$k2 = $temp[1];
	@a1 = split(/\t/,$exp1{$k1});
	@a2 = split(/\t/,$exp2{$k2});
	$R -> set(x1,\@a1);
	$R -> set(x2,\@a2);
	$out = $R -> run(q`cor.test(x1,x2)`);
	print"$temp[0]\t$temp[1]\t";
	if($out =~ /p-value [<|=] (.*)/){
		print "$1";
	}
	@a=split(/\n/,$out);
	for($i=1;$i<@a;$i++){
		if (($a[$i] =~/cor/) && ($a[$i]) !~ /corre/){
			print "\t$a[$i+1]\n";
		}
	}
}
