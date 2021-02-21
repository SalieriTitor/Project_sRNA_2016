# used to draw the Manhattan plot

use strict;
use warnings;
use SVG;
use Math::Complex;
use List::Util qw(max min sum);
if(!@ARGV){
#	print "Usage : perl script inputfile >output\n";
#	print "use to draw the hotmapspot for maize genome\n";
#	print "input file format :clustername clusterchr	clusterstart	clusterend	eQTLchr	eQTLstart	eQTLend	eQTLSNPnumber	leadpvalue(not -logp please).\n";
#	die;
}
my $svg = SVG -> new(width => 3100,height => 3000);
############frame drawing#########
$svg -> line(x1 =>193 ,y1=>1300 ,x2=>2706,y2=>1300,stroke =>"grey","stroke-width" => 3);
$svg -> line(x1 =>193 ,y1=>2800 ,x2=>2706,y2=>2800,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>197 ,y1=>1300 ,x2=>197,y2=>2800,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>2703 ,y1=>1300 ,x2=>2703,y2=>2800,stroke =>"grey","stroke-width" => 3);

my @chr;
$chr[0]=0;
$chr[1]=307041717;
$chr[2]=244442276;
$chr[3]=235667834;
$chr[4]=246994605;
$chr[5]=223902240;
$chr[6]=174033170;
$chr[7]=182381542;
$chr[8]=181122637;
$chr[9]=159769782;
$chr[10]=150982314;
my $sum = sum @chr;
my $ratio = 0;


my %sumchr;
$sumchr{0}=0;
my $sumchr=0;
for(my $i=1;$i<=10;$i++){
	$sumchr+=$chr[$i];
	$sumchr{$i}=$sumchr;
}

for (my $i=1;$i<10;$i++){
	$ratio += 2500 * $chr[$i]/$sum;
	$svg -> line(x1 =>200+$ratio ,y1=>1300 ,x2=>200+$ratio,y2=>2800,stroke =>"grey","stroke-width" => 1);
}

$ratio = 0;
my $ratio_each;
for (my $i=1;$i<=10;$i++){
	$ratio_each=2500 * $chr[$i]/$sum;
	$svg -> text(x=>150+$ratio + 0.5* $ratio_each ,y=> 2850, "font-family" => "Arial","text-anchor" => "start","-cdata" => "chr$i","font-size" => 48,'font-weight'=>"bold",'font-style' => 'italic');
	$ratio += $ratio_each;
}

my $genepos_y =2800;

my %snppos;
my %snppvalue;
my %snptype;
my %snpcolor;
my %chrsnp;
open(SNP,$ARGV[0]);
my $header = <SNP>;
my $remove_threhold = 0.01;
my $logrm = -logn($remove_threhold,10);

while(my $snp=<SNP>){
	chomp $snp;
	my @snpinfo = split(/\t/,$snp);
	if($snpinfo[3] < $remove_threhold ){							###################remove the low value point to reduce the size of figure!!!!
		$chrsnp{$snpinfo[0]} = $snpinfo[1];
		$snppos{$snpinfo[0]} = $snpinfo[2];
		$snptype{$snpinfo[0]}=$snpinfo[4]; #check the snp type 'SNP' or 'InDel',if not 'InDel', regarded as 'SNP'
		if ($snpinfo[5]){
			$snpcolor{$snpinfo[0]} = $snpinfo[5];
		}# to use the special color
		
		$snppvalue{$snpinfo[0]} = -logn($snpinfo[3],10);
	}
}
my $maxp = int(max (values %snppvalue)) + 1;
my $heightpiex = 1500; #x2
my $ratiop =  $heightpiex / ($maxp-$logrm);

for my $keys(keys %snppos){
	# detemin the positon of the snp point
	my $chr = $chrsnp{$keys}-1;
	my $snpsite_x;
		$snpsite_x = ($sumchr{$chr} + $snppos{$keys})/$sumchr * 2500 + 200;
		
		
	my $snpsite_y = int($genepos_y - 5 - (($snppvalue{$keys}-$logrm) * $ratiop));
	# determin the symbol of the snp point . InDel with Triangle ,other with circle.
	my $snpcolor;
	if( defined($snptype{$keys}) && ($snptype{$keys} eq 'InDel')){
		if (defined ($snpcolor{$keys})){
			$snpcolor = $snpcolor{$keys};
			my $path = $svg -> get_path(x => [$snpsite_x-6,$snpsite_x,$snpsite_x+6],y => [$snpsite_y,$snpsite_y+8, $snpsite_y],-type => 'polygon');
			$svg -> polygon(%$path,"fill" => "$snpcolor",'stroke-width' => 0);
		}else{

		}
	}else{
		if (defined ($snpcolor{$keys})){
			$snpcolor = $snpcolor{$keys};
												#print "$snpcolor\n";
			$svg -> circle(cx =>$snpsite_x ,cy =>$snpsite_y ,r=> 5,'fill' => $snpcolor,style =>{'stroke-width' => 0});
		}else{
			if($chr % 2 == 0){
				$snpcolor = "rgba(0,0,255,0.6)";
			}else{
				$snpcolor = 'rgba(128,128,128,0.6)';
			}
			$svg -> circle(cx => $snpsite_x,cy => $snpsite_y,r=> 5,'fill' => $snpcolor,style =>{'stroke-width' => 0});
		}# to draw the point with special color.
	}
}

my $threhold = 8.17e-7;
my $threlinepos = -logn($threhold,10);
$threlinepos = int($genepos_y - 5 - (($threlinepos-$logrm) * $ratiop));
$svg -> line(x1 =>198 ,y1=>$threlinepos ,x2=>2700,y2=>$threlinepos,stroke =>"grey","stroke-width" => 2,'stroke-dasharray'=>"5,5");


####################the tick################
my $tick_sep = 2;
my $tick_pix = $tick_sep * $ratiop;
my $ticky_min = 0;
my $i = $logrm;
while(2800 - $ticky_min >= 1300){
	my $ticky =  int(2800-$ticky_min);
	$svg -> line(x1 =>187 ,y1=>$ticky ,x2=>200,y2=>$ticky,stroke =>"black","stroke-width" => 6);
	$svg -> text(x=>170 ,y=> $ticky+10, "font-family" => "Arial","text-anchor" => "end","-cdata" => "$i","font-size" => 48,'font-weight'=>"bold");
	$ticky_min += $tick_pix;
	$i+= $tick_sep;
}
$svg -> text(x=>110 ,y=>1250, "font-family" => "Arial","text-anchor" => "start","-cdata" => "-LogP","font-size" => 48,'font-weight'=>"bold",'font-style' => 'italic');
############output#######
my $result = $svg -> xmlify;
print $result;
