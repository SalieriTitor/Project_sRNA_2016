#Another type of eQTL map figure.

use SVG;
use Math::Complex;
use List::Util qw(max min sum);
#if(!@ARGV){
#	print "Usage : perl script inputfile >output\n";
#	print "use to draw the hotmapspot for maize genome\n";
#	print "input file format :clustername clusterchr	clusterstart	clusterend	eQTLchr	eQTLstart	eQTLend	eQTLSNPnumber	leadpvalue(not -logp please).\n";
#	die;
#}
my $svg = SVG -> new(width => 3500,height => 3000);
$svg -> line(x1 =>197 ,y1=>300 ,x2=>2703,y2=>300,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>197 ,y1=>1300 ,x2=>2703,y2=>1300,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>200 ,y1=>300 ,x2=>200,y2=>1300,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>2700 ,y1=>300 ,x2=>2700,y2=>1300,stroke =>"black","stroke-width" => 6);
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
for (my $i=1;$i<=10;$i++){
	$ratio += 2500 * $chr[$i]/$sum;
	$svg -> line(x1 =>200+$ratio ,y1=>300 ,x2=>200+$ratio,y2=>1300,stroke =>"grey","stroke-width" => 1);
}
$ratio = 0;
my $ratio_each;
for (my $i=1;$i<=10;$i++){
	$ratio_each=2500 * $chr[$i]/$sum;
	$svg -> text(x=>150+$ratio + 0.5* $ratio_each ,y=> 1350, "font-family" => "Arial","text-anchor" => "start","-cdata" => "chr$i","font-size" => 48,'font-weight'=>"bold",'font-style' => 'italic');
	$ratio += $ratio_each;
}


############colordefined & scale bar##########
my $redmax=255;
my $redmin=0;
my $greenmax=255;
my $greenmin=0;
my $bluemax=0;
my $bluemin=0;
for(my $i=0;$i<=255;$i++){
	my $red = $redmin + $i;
	my $green = $greenmax-$i;
	#my $blue = $bluemax -$i;
	$svg -> line(x1 =>2800 ,y1=>1300-3.6*$i ,x2=>2900 ,y2=>1300-3.6*$i ,stroke => "rgb($red,$green,0)","stroke-width" => 6);#scale bar
}
$svg -> text(x => 2770 ,y => 350,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"-logP",'font-size' => 72,'font-weight'=>"bold",'font-style' => 'italic');
##########size of circle####
$svg -> circle(cx=>3100,cy=>400,r=>5,'fill' => "grey",'stroke-width' => 0);
$svg -> circle(cx=>3100,cy=>475,r=>7,'fill' => "grey",'stroke-width' => 0);
$svg -> circle(cx=>3100,cy=>550,r=>9,'fill' => "grey",'stroke-width' => 0);
$svg -> circle(cx=>3100,cy=>625,r=>11,'fill' => "grey",'stroke-width' => 0);
$svg -> text(x => 3100 ,y => 350,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"Number of SNP",'font-size' => 48,'font-weight'=>"bold");

$svg -> text(x => 3150 ,y => 420,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"<=10",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => 3150 ,y => 495,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"10~50",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => 3150 ,y => 570,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"50~100",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => 3150 ,y => 645,"font-family" => "Arial","text-anchor" => "start","-cdata"=>">100",'font-size' => 48,'font-weight'=>"bold");

###########figure drawing##########
my $max = 0;
my $min = 1;
my $pointmax = 0;
my $pointmin = 99999; 
my %sumchr;
$sumchr{0}=0;
my $sumchr=0;
for(my $i=1;$i<=10;$i++){
	$sumchr+=$chr[$i];
	$sumchr{$i}=$sumchr;
}

open(FILE,$ARGV[0]);
my %drawlist;
my $drawid = 0;
while(<FILE>){
	chomp;
	my @a=split(/\t/);
	if ($a[1] =~/B73V4/ || $a[4] =~ /B73V4/ || $a[4] eq "Pt" || $a[4] eq "Mt" || $a[1] eq "Pt" || $a[1] eq "Mt"){
		
	}else{
		$drawid++;
		$drawlist{$drawid}=$_;
		if($max < $a[8]){
			$max = $a[8];
		}
		if($min > $a[8]){
			$min = $a[8];
		}
	}
}

my $logmax=int(-logn($min,10))+1;
my $logmin=int(-logn($max,10));
my $logmid=($logmax+$logmin)/2;
$svg -> text(x => 2920 ,y => 410,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"$logmax",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => 2920 ,y => 1310,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"$logmin",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => 2920 ,y => 860,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"$logmid",'font-size' => 48,'font-weight'=>"bold");


my %eQTLcount;
$axisuse = 0;
for ($i=1300;$i>=280;$i-=95){
	$svg -> line(x1 =>180 ,y1=>$i ,x2=>200,y2=>$i,stroke =>"black","stroke-width" => 3);
	$svg -> text(x => 165 ,y => $i+15,"font-family" => "Arial","text-anchor" => "end","-cdata"=>"$axisuse",'font-size' => 48,'font-weight'=>"bold");
	$axisuse +=100;
}


for my $keys(sort{$a<=>$b} keys %drawlist){
	my @a=split(/\t/,$drawlist{$keys});
	my $usey = $a[1]-1;											#change $usex -> $usey.

	#print "$posx\n";
	my $usex = $a[4]-1;											#change $usey -> $usex.
	my $posx = ($sumchr{$usex} + $a[5])/$sumchr * 2500 + 200;	#change $a[2] -> $a[5].
	
	$locationkb = int($a[5]/100000);
	
	if(defined($eQTLcount{$a[4]}{$locationkb})){
		$eQTLcount{$a[4]}{$locationkb} ++;
		$posy = my $posy = 1294 - $eQTLcount{$a[4]}{$locationkb} *0.95;
	}else{
		$eQTLcount{$a[4]}{$locationkb} =1;
		$posy = my $posy = 1294 - $eQTLcount{$a[4]}{$locationkb} *0.95;
	}
	
	
	my $drawred=int((-logn($a[8],10)-$logmin)/($logmax-$logmin) * 255);
	my $drawgreen=255 - $drawred;
	my $drawblue=0;
	my $dotr;
	if($a[7]<=10){
		$dotr = 5;
	}elsif($a[7]<=50){
		$dotr = 7;
	}elsif($a[7]<=100){
		$dotr = 9;
	}else{
		$dotr = 11;
	}
	$svg -> circle(cx=>$posx,cy=>$posy,r=>$dotr,'fill' => "rgb($drawred,$drawgreen,$drawblue)",'stroke-width' => 0)
}


############output#######
my $result = $svg -> xmlify;
print $result;
