#Split Genome by length(give step and sliding length).

open(FILE,$ARGV[0]);
$seq="";
$chrname = <FILE>;
chomp $chrname;
$chrname =~ /^>(.*) dna/;
$chr =$1;
while(<FILE>){
	chomp;
	if ($_=~/^>/){
		$_ =~ /^>(.*) dna/;
		$length=length($seq);
		if($length){
			for($i=0;$i<=$length;$i+=$ARGV[2]){
				$subseq=substr($seq,$i,$ARGV[1]);
				$startnum = $i+1;
				$endnum = $i + $ARGV[1];
				$outname = "chr$chr"."S$startnum"."E$endnum";
				open(OUT,">>$ARGV[3]/$outname") || die;
				print OUT ">$outname\n$subseq\n";
			}
		}
		$chr = $1;
		$seq="";
	}else{
		$seq.=$_;
	}
}

			$length = length($seq);
			for($i=0;$i<=$length;$i+=$ARGV[2]){
				$subseq=substr($seq,$i,$ARGV[1]);
				$startnum = $i+1;
				$endnum = $i + $ARGV[1];
				$outname = "chr$chr"."S$startnum"."E$endnum";
				open(OUT,">>$ARGV[3]/$outname") || die;
				print OUT ">$outname\n$subseq\n";
			}
