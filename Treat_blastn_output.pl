# used to treat the output of blastn
open(FILE,$ARGV[0]);
while(<FILE>){
	
	chomp;
	@a=split(/\t/);
	$lociBase =$a[0];
	$lociBase =~/chr(.*)S(.*)E(.*)/;
	$chr = $1;
	$startBase = $2;
	$endBase = $3;
	if($a[7] == $a[8]){
		$ratio = 1;
		$totallen = $a[8] - $a[6]+1;
	}else{
		$length1 = $a[7] - $a[6]+1;
		$length2 = $a[8] - $a[9]+1;
		$length = $length1 + $length2;
		$totallen = $a[8] - $a[6]+1;
		$ratio = $length / $totallen;
	}
	$regionstart = $startBase + $a[6] - 1;
	$regionend = $startBase + $a[8] - 1;
	print "$chr\t$regionstart\t$regionend\t$totallen\t$ratio\n";
}
