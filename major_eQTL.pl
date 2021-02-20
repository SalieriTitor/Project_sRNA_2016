if(!@ARGV){
	print "Usage : perl script outputof_treatJEoutput.pl outputof_LDtreat.pl outputof_eQTLclusterdefine.pl >outputfile \n";
	print "to get the final eQTL list\n";
}

my %eqtl;
open(FILE3,$ARGV[2]);
while(<FILE3>){
	chomp;
	$_=~s/\r//;
	@a=split(/\t/);
	$key="$a[6]"."C$a[7]"."L$a[9]";
	$eqtl{$key}=$_;
	#print "$key\n";
	#print "$eqtl{$key}\n";
}
my %jeout;
open(FILE1,$ARGV[0]);
while(<FILE1>){
	chomp;
	$_=~s/\r//;
	@a=split(/\t/,$_);
	$key = "$a[0]" . "$a[1]";
	$jeout{$key} = $a[2];
}


open(FILE2,$ARGV[1]);
while(<FILE2>){
	chomp;
	$_=~s/\r//;
	if ($_=~/^cluster/){
		@a=split(/\t/);
		$key1="$a[0]" . "$a[1]";
		$key2="$a[0]" . "$a[2]";
		#print "$eqtl{$key1}\n";
		if(($jeout{$key1}=~/cluster/) || ($jeout{$key2}=~/cluster/)){
			if(($jeout{$key1} =~/cluster/) && ($jeout{$key2} =~/cluster/)){
			}elsif($jeout{$key1} =~/cluster/){
				$temp = $jeout{$key1};
				if($jeout{$temp} > $jeout{$key2}){
					$jeout{$key2} = $temp;
				}elsif($jeout{$temp} < $jeout{$key2}){
					$jeout{$temp} = $key2;
					$jeout{$key1} = $key2;
				}
			}else{
				$temp = $jeout{$key2};
				if($jeout{$temp} > $jeout{$key1}){
					$jeout{$key1} = $temp;
				}elsif($jeout{$temp} < $jeout{$key1}){
					$jeout{$temp} = $key1;
					$jeout{$key2} = $key1;
				}
			}
		}else{
			if($jeout{$key1} > $jeout{$key2}){
				$jeout{$key2} = $key1;
			}else{
				$jeout{$key1} = $key2;
			}
		}
	}elsif($_=~/deleted/){
	}else{
		print "$_\n";
	}
}
for $keys(sort keys %jeout){
	if (!($jeout{$keys} =~ /cluster/)){
		print "$eqtl{$keys}\n"; 
	}
}
