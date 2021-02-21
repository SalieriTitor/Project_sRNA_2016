use strict;
use warnings;
use SVG;
use Math::Complex;
use List::Util qw(max min sum);
if(!@ARGV){
	print "Usage : perl script inputfile >output\n";
	print "use to draw the hotmapspot for maize genome\n";
	print "input file format :clustername clusterchr	clusterstart	clusterend	eQTLchr	eQTLstart	eQTLend	eQTLSNPnumber	leadpvalue(not -logp please).\n";
	die;
}
my $svg = SVG -> new(width => 3100,height => 3000);
############frame drawing#########
$svg -> line(x1 =>197 ,y1=>300 ,x2=>2703,y2=>300,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>197 ,y1=>2800 ,x2=>2703,y2=>2800,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>200 ,y1=>300 ,x2=>200,y2=>2800,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>2700 ,y1=>300 ,x2=>2700,y2=>2800,stroke =>"black","stroke-width" => 6);
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
	$svg -> line(x1 =>197 ,y1=>2800-$ratio ,x2=>2703,y2=>2800-$ratio,stroke =>"grey","stroke-width" => 1);
	$svg -> line(x1 =>200+$ratio ,y1=>300 ,x2=>200+$ratio,y2=>2800,stroke =>"grey","stroke-width" => 1);
}
$ratio = 0;
my $ratio_each;
my $rotatex;
my $rotatey;
for (my $i=1;$i<=10;$i++){
	$ratio_each=2500 * $chr[$i]/$sum;
	$svg -> text(x=>150+$ratio + 0.5* $ratio_each ,y=> 2850, "font-family" => "Arial","text-anchor" => "start","-cdata" => "chr$i","font-size" => 48,'font-weight'=>"bold",'font-style' => 'italic');
	$rotatex=180;
	$rotatey=2870-$ratio-0.5*$ratio_each;
	$svg -> text(x=>$rotatex,y=>$rotatey, "font-family" => "Arial","text-anchor" => "start","-cdata" => "chr$i","font-size" => 48,'font-weight'=>"bold",'font-style' => 'italic',transform =>"rotate(-90,$rotatex,$rotatey)");
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
	$svg -> line(x1 =>2800 ,y1=>2800-4*$i ,x2=>2900 ,y2=>2800-4*$i ,stroke => "rgb($red,$green,0)","stroke-width" => 6);#scale bar
}
$svg -> text(x => 2770 ,y => 1750,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"-logP",'font-size' => 72,'font-weight'=>"bold",'font-style' => 'italic');
##########size of circle####
$svg -> circle(cx=>2850,cy=>500,r=>5,'fill' => "grey",'stroke-width' => 0);
$svg -> circle(cx=>2850,cy=>750,r=>7,'fill' => "grey",'stroke-width' => 0);
$svg -> circle(cx=>2850,cy=>1000,r=>9,'fill' => "grey",'stroke-width' => 0);
$svg -> circle(cx=>2850,cy=>1250,r=>11,'fill' => "grey",'stroke-width' => 0);
$svg -> text(x => 2950 ,y => 650,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"Number of SNP",'font-size' => 60,'font-weight'=>"bold",transform =>"rotate(90,2950,650)");

$svg -> text(x => 2840 ,y => 530,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"<=10",'font-size' => 48,'font-weight'=>"bold",transform =>"rotate(90,2840,530)");
$svg -> text(x => 2840 ,y => 780,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"10~50",'font-size' => 48,'font-weight'=>"bold",transform =>"rotate(90,2840,780)");
$svg -> text(x => 2840 ,y => 1030,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"50~100",'font-size' => 48,'font-weight'=>"bold",transform =>"rotate(90,2840,1030)");
$svg -> text(x => 2840 ,y => 1280,"font-family" => "Arial","text-anchor" => "start","-cdata"=>">100",'font-size' => 48,'font-weight'=>"bold",transform =>"rotate(90,2840,1280)");



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
$svg -> text(x => 2920 ,y => 1810,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"$logmax",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => 2920 ,y => 2810,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"$logmin",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => 2920 ,y => 2310,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"$logmid",'font-size' => 48,'font-weight'=>"bold");

for my $keys(sort{$a<=>$b} keys %drawlist){
	my @a=split(/\t/,$drawlist{$keys});
	my $usey = $a[1]-1;											#change $usex -> $usey.

	#print "$posx\n";
	my $usex = $a[4]-1;											#change $usey -> $usex.
	my $posx = ($sumchr{$usex} + $a[5])/$sumchr * 2500 + 200;	#change $a[2] -> $a[5].
	my $posy = 2800 - ($sumchr{$usey} + $a[2])/$sumchr * 2500;	#change $a[5] -> $a[2].
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
#########box drawing##########
$svg -> line(x1 =>197 ,y1=>300 ,x2=>2703,y2=>300,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>197 ,y1=>2800 ,x2=>2703,y2=>2800,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>200 ,y1=>300 ,x2=>200,y2=>2800,stroke =>"black","stroke-width" => 6);
$svg -> line(x1 =>2700 ,y1=>300 ,x2=>2700,y2=>2800,stroke =>"black","stroke-width" => 6);

############output#######
my $result = $svg -> xmlify;
print $result;
