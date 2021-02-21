#use treated blastn output to identify IR region

open(FILE,$ARGV[0]);
while(<FILE>){
	chomp;
	@a=split(/\t/);
	$mergeid = "C$a[0]"."S$a[1]"."E$a[2]";
	$privateid = "C$a[3]"."S$a[4]"."E$a[5]";
	$Ratio{$mergeid}{$privateid} = $a[7];
	$Len{$mergeid}{$privateid} = $a[6];
	$Chr{$mergeid}{$privateid} = $a[0];
	$Start{$mergeid}{$privateid} = $a[4];
	$End{$mergeid}{$privateid} = $a[5]; 
	$regions{$mergeid} = $mergeid;
}
for $keys(sort keys %regions){
	$temp = $Ratio{$keys};
	%savetemp = "";
	
	$keys=~/C(.*)S(.*)E(.*)/;
	for($i=$2;$i<=$3;$i++){
		$savetemp{$i}=0;
	}
	
	for $keys2(sort {$hash{$b}<=>$hash{$a}} keys %$temp){
		$count = 0;
		$start = $Start{$keys}{$keys2};
		$end = $End{$keys}{$keys2};
		$ratio = $Ratio{$keys}{$keys2};
		$length = $Len{$keys}{$keys2};
		$chr = $Chr{$keys}{$keys2};
		for ($m = $start ;$m<=$end;$m++){
			$count += $savetemp{$m};
		}
		if($count == 0){
			print "$chr\t$start\t$end\t$length\t$ratio\n";
			for ($m = $start ;$m<=$end;$m++){
				if($savetemp{$m} == 0){
					$savetemp{$m} = 1;
				}
			}
			
		}
	}
}

