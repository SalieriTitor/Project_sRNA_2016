# matrix transposition
open(FILE,$ARGV[0]);
$m=0;
while(<FILE>){
	$n=0;
	chomp;
	@array=split(/\t/,$_);
	for $member(@array){
		if ($member eq 'NULL'){
			$matrix[$m][$n] = 0;
		}else{
			$matrix[$m][$n]=$member;
		}
		$n++;
	}
	$m++;
}

for($i=0;$i<$n;$i++){
	for($x=0;$x<$m;$x++){
		if (($m-$x) == 1){
			print "$matrix[$x][$i]";
		}else{
			print "$matrix[$x][$i]\t";
		}
	}
	print "\n";
}
