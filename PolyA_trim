##polyA去除的标准：
#	default parameters:
#		1、poly(A/T)>=30%;
#		2、AT content >= 80%;
#######################require#########################
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);
use IO::File;
use strict;
use warnings;
use IO::Compress::Gzip qw(gzip $GzipError);
use Getopt::Std;
use vars qw($opt_p $opt_a);
#########################system time###################
my ($sec,$min,$hour,$day,$mon,$year)=localtime;
$year+=1900;
$mon++;
my $system_time="$year\_$mon\_$day\_$hour\_$min\_$sec";
########################################################

my $directory=$ARGV[0];
my $seqname;
my $seq;
###########parameter##########################
my $percentat=0.8;
my $poly=0.3;
getopts('p:a:');
if(defined($opt_p)){
	$percentat=$opt_p;
}
if(defined($opt_a)){
	$poly=$opt_a;
}
##################################################
opendir(DIR,$directory) or die "couldn't found this directory";
my @file_name=readdir DIR;
mkdir "$directory/result" or die "could't make output directory";
my $stat="rmpoly_$system_time.txt";
open (STAT,">>$directory/result/$stat");
print STAT "start running time:$system_time\n";
print STAT "max A/T content:$percentat.\nmax polyA(T) length:$poly\n";
print STAT "Filename\tinput\toutput\n";

for my $file(@file_name){
	my $seq_number=0;
	my $success=0;
	if(($file=~/(.*).fa/) || ($file=~/(.*).fa.gz/)){
		my $z = new IO::Uncompress::Gunzip("$directory/$file");
		my $outz=new IO::Compress::Gzip("$directory/result/rmpoly_$1.fa.gz");
		my $seqname=$z->getline();
		while($seqname){
			$seq=$z->getline();
			$seq_number++;
			chomp $seqname;
			chomp $seq;
			if (&polytrim($seq,$poly,$percentat)){
				$outz->print(">$seq_number\n$seq\n");
				$success++;
			}
			$seqname=$z->getline();	
		}
		print STAT "$file\t$seq_number\t$success\n";
	}	
}


#poly的判断,如果满足输出需求返回1,被过滤输出0;
sub polytrim{
	my @char;
	my $value=1;
	my $polya=0;
	my $polyt=0;
	my $countat=0;
	my ($seq,$poly,$percentat)=@_;
	my $len=length($seq);
	@char=split(//,$seq);
	for(my $i=0;$i<$len;$i++){
		if(($char[$i] eq "A") || ($char[$i] eq "a")){
			$polya++;
			$polyt=0;
			$countat++;
			if ($polya/$len>$poly){
				$value=0;
				last;
			}
		}elsif(($char[$i] eq "T")||($char[$i] eq "t")){
			$polyt++;
			$polya=0;
			$countat++;
			if ($polyt/$len>$poly){
				$value=0;
				last;
			}
		}elsif(($char[$i] eq "N") || ($char[$i] eq "n")){
			$polyt++;
			$polya++;
			$countat++;
		}else{
			$polya=0;
			$polyt=0;
		}
	}
	if($countat/$len>$percentat){
		$value=0;
	}
	return $value;
}

