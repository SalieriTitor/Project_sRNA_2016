if(!@ARGV){
	print "Usage:perl script outputdir(from SNP_need_calculate.pl) expfiledir \n";
	print "expfile dir is the director of ephenotype for eQTL calculate\n";
}
opendir (DIR1,$ARGV[0]) || die "could not found the input directory\n";
mkdir preparedforJE || die "can't make the output directory\n";
@inputfile1 =  readdir DIR1;
for $file (@inputfile1){
	if($file =~/(.*)_(.*)/){
		my %exphash;
		chomp $file;
		open(OUT,">preparedforJE/$file.prepared");
		open(EXP,"$ARGV[1]/$1");
		while(<EXP>){
			chomp;
			@a=split(/\t/);
			$exphash{$a[0]}=$a[1];
		}
		open(FILE,"$ARGV[0]/$file");
		$header2 = <FILE>;
		chomp $header2;
		print OUT "$header2\n";
		print OUT "exp";
		@a=split(/\t/,$header2);
		for ($i=1;$i<@a;$i++){
			print OUT "\t$exphash{$a[$i]}";
		}
		print OUT "\n";
		while(<FILE>){
			chomp;
			print OUT "$_\n";
		}
	}

}
