#Transform eMatrix to biomarker
if(!@ARGV){
	print "Usage : perl script ematrix >output\n";
	print "transformthe eMatrix to biomarker. rate could change alter in script line 6\n";
	print "eMatrix format : inbred_in_col , seq_in_row\n";
}
$rate = 0.15;
open(MATRIX,$ARGV[0]);
$header = <MATRIX>;
chomp $header;
print "$header\n";
@list =split(/\t/,$header);
for ($i=1;$i<@list;$i++){
	$sample{$i} = $a[$i];
}
while(<MATRIX>){
	chomp;
	@data = split(/\t/);
	%infohash = biomarker($rate,@data);
	print "$data[0]";
	for $keys(sort {$a<=>$b} keys %infohash){
		print "\t$infohash{$keys}";
	}
	print "\n";
}


sub biomarker(){
	my %output;
	my %hashforsort;
	my ($rate,@data) = @_;
	for ($i = 1;$i<@data;$i++){
		$hashforsort{$i} = $data[$i];
	}
	$count = 1;
	for my $keys(sort{$hashforsort{$a} <=> $hashforsort{$b}} keys %hashforsort){
		if($count/(@data+1) <= 0.15){
			$output{$keys} = 0;
		}elsif($count/(@data+1) < 0.85){
			$output{$keys} = 3;
		}else{
			$output{$keys} = 1;
		}
		$count++;
	}
	return %output;
}
