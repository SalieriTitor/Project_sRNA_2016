#Use to trim low-quality reads in fq.gz
#directory version;compress version;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);
use IO::File;
use strict;
use warnings;
use IO::Compress::Gzip qw(gzip $GzipError);
#########################system time###################
my ($sec,$min,$hour,$day,$mon,$year)=localtime;
$year+=1900;
$mon++;
my $system_time="$year\_$mon\_$day\_$hour\_$min\_$sec";
########################################################

###########defaut_value##########################
my $q_value=20;
my $q_percent=0.5;
my $n_percent=0.1;
##############parameter treatment################
my %parhash;
my $directory=shift @ARGV;
my $count=0;
my $array_number=@ARGV;
for my $par(@ARGV){
	if ($par=~/-/ && ($count+1 <= $array_number)){
		$parhash{$par}=$ARGV[$count+1];
	}
	$count++;
}

if (defined($parhash{-q})){
	$q_value=$parhash{-q};
}
if (defined($parhash{-qp})){
	$q_percent=$parhash{-qp};
}
if (defined($parhash{-n})){
	$n_percent=$parhash{-n};
}
#for my $key(sort keys %parhash){
#	print "$key\t$parhash{$key}\n";
#}print test
##################################################

opendir(DIR,$directory) or die "couldn't found this directory";
my @file_name=readdir DIR;
mkdir "$directory/result" or die "could't make output directory";
my $stat="qtrimstat_$system_time.txt";
open (STAT,">>$directory/result/$stat");
print STAT "start running time:$system_time\n";
print STAT "parameter:\n\tthreshold quality value:$q_value\n\tthreshold q_value content:$q_percent\n\tthreshold \"N\" content:$n_percent\n";
print STAT "filename\tinput\toutput\n";

for  my $filename(sort @file_name){
	my $err=0;
	my $seq_number=0;
	my $seq_success=0;
	if($filename=~/(.*)\.fq\.gz$/ || $filename=~/(.*)\.fastq\.gz$/){
		my $z = new IO::Uncompress::Gunzip("$directory/$filename");
		my $outz=new IO::Compress::Gzip("$directory/result/qtrimed_$1.fa.gz");
		my $seqname=$z->getline();
		while($seqname){
			my $seq=$z->getline();
			my $plus=$z->getline();
			my $quality=$z->getline();
			if (!($seqname=~/^@/)){
				print STAT "badformat in $filename,please check the file\n";
				$err=1;
				last;
			}
			$seq_number++;
			chomp $seqname;
			chomp $seq;
			chomp $quality;
			if(&q_stat($quality,$q_value,$q_percent) && &n_stat($seq,$n_percent)){
				$outz->print (">$seq_number\n$seq\n");
				$seq_success++;
			}
			$seqname=$z->getline();
		}
		if ($err==0){
			print STAT "$filename\t$seq_number\t$seq_success\n";
		}
	}
}
############质量检测，输入（质量行，q阈值，比例）##########################
sub q_stat(){
	my $q;
	my $total=0;
	my $fail=0;
	my ($quality,$q_value,$q_percent)=@_;
	for(my $i=0;$i<length($quality);$i++){
		$q=ord(substr($quality,$i,1))-33;
		if($q<$q_value){
			$fail++;
			$total++;
		}else{
			$total++;
		}
	}
	if(1-$fail/$total>=$q_percent){
		return 1;
	}else{
		return 0;
	}
}
##########################################################

######################N检测 输入（序列，比例）############
sub n_stat(){
	my($seq,$n_percent)=@_;
	my $char;
	my $total=0;
	my $fail=0;
	for(my $i=0;$i<length($seq);$i++){
		$char=substr($seq,$i,1);
		if(($char eq "N") || ($char eq "n")){
			$fail++;
			$total++;
		}else{
			$total++;
		}
	}
	if($fail/$total<=$n_percent){
		return 1;
	}else{
		return 0;
	}
}
###########################################################
