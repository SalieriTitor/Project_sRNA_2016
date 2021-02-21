#find the candidate eQTL
if(!@ARGV){
	print "Usage : perl script threholdpoint.bed threholdpoint > eQTLcluster.\n";
	print "use to treat the threholdpoint bed file\n";
	print "inputfile format : chr	pos-1	pos	clustername	pvalue\n";
	print "inputfile format2 : cluster	markername	chr	pos	pvalue\n";
	print "output format : clustername	eQTLnumber	leaderSNPname	lead_pValue\n";
	die;
}
open(BED,$ARGV[0]);
while(<BED>){
	chomp;
	@a=split(/\t/);
	$clusterlist{$a[3]} = $a[3];
}
$command = 'awk \'$4>=3\'';
for $list(sort keys %clusterlist){
	@result=`cat "$ARGV[0]" |grep "$list" |sortBed -i stdin |mergeBed -i stdin -d 10000 -c 1,5 -o count,min |$command`;
	@markerinfo = `cat "$ARGV[1]" |grep "$list"`;
	for $keys(sort @result){
		chomp $keys;
		@a=split(/\t/,$keys);
		for $marker(@markerinfo){
			chomp $marker;
			@b=split(/\t/,$marker);
			if(($b[4]==$a[4]) && ($b[2]==$a[0]) && ($b[3]>=$a[1]) && ($b[3]<=$a[2])){
				$start=$b[3]-1;
				print "$keys\t$b[1]\t$list\t$b[2]\t$start\t$b[3]\n";
				last;
			}
		}
		
	}
}
