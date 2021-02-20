# used to filter the candidate eQTL by LD and p-value.
if(!@ARGV){
	print "Usage : perl script eQTLcluster LDouttreat >output\n";
	print "use to merge the eQTL by the LD.\n";
	print "format for QTLcluster : chr	start	end	leadP-value	leadSNP	clustername\n";
	print "LDouttreat format : Locus1	Position1	Locus2	Position2	R^2\n";
}

open(LDOUT,$ARGV[1]);
$head=<LDOUT>;
my %ldhash;
my %equal;
while(<LDOUT>){
	chomp;
	@a=split(/\t/);
	$key1 = "C$a[0]L$a[1]";
	$key2 = "C$a[2]L$a[3]";
	$ldhash{$key1}{$key2}=$a[4];
}
open(EQTL,$ARGV[0]);
while(<EQTL>){
	chomp;
	@a=split(/\t/);
	$key="C$a[7]L$a[9]";
	$clusterhash{$a[6]}{$key}=$_;
	$valuehash{$a[6]}{$key}=$a[4];
}
for $keys(sort keys %clusterhash){
	$temphash=$clusterhash{$keys};
	LABEL2: for $keys2(sort keys %$temphash){
		#print "$keys2\n";
		LABEL3: for $keys3(sort keys %$temphash){
			#print "$keys3\n";
			if($keys2 ne $keys3){
				#print "$keys2\t$keys3\n";
				if(((defined($ldhash{$keys2}{$keys3})) && ($ldhash{$keys2}{$keys3}>=0.1)) || ((defined($ldhash{$keys3}{$keys2})) && ($ldhash{$keys3}{$keys2}>=0.1))){
					if($valuehash{$keys}{$keys2} > $valuehash{$keys}{$keys3}){
						$valuehash{$keys}{$keys2} = 100;
						$clusterhash{$keys}{$keys2} = "deleted";
					}elsif($valuehash{$keys}{$keys2} < $valuehash{$keys}{$keys3}){
						$valuehash{$keys}{$keys3} = 100;
						$clusterhash{$keys}{$keys3} = "deleted";
					}else{
						if($valuehash{$keys}{$keys2} != 100){
							$clusterhash{$keys}{$keys3} = "deleted";
							print "$keys\t$keys2\t$keys3\n";
						}
					}
				}
			}
		} 
	}
}
for $keys(sort keys %clusterhash){
	$temphash=$clusterhash{$keys};
	for $keys2(sort keys %$temphash){
		$forprint = $clusterhash{$keys}{$keys2};
		print "$forprint\n";
	}
}
