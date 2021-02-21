#used to draw LD figure

use strict;
use warnings;
use SVG;
use Math::Complex;
use List::Util qw(max min sum);

if(!@ARGV){
	print "Usage : perl script LDouttreatfile >output.\n";
	print "do not use to choose to much SNPs,better not over 1000\n";
	print "LD_treat format :Locus1	Position1	Locus2	Position2	R^2(with header please)\n";
	print "LD_treat get : cut -f 1,2,7,8,14 LDoutput(TASSEL5)\n";
}
my $svg = SVG -> new(width => 2500,height => 2500);
############colordefined & scale bar########## just use you like,remove/add the "#" before the bar to change. also change the color next.
my $redmax=255;
my $redmin=0;
my $greenmax=255;
my $greenmin=0;
my $bluemax=255;
my $bluemin=0;

my $scalebarx=2300;
my $scalebary=2000;
#for(my $i=0;$i<=255;$i++){				#red2green
#	my $red = $redmin + $i;
#	my $green = $greenmax-$i;
#	$svg -> line(x1 =>$scalebarx ,y1 =>$scalebary-4*$i ,x2 =>$scalebarx+100 ,y2 =>$scalebary-4*$i ,stroke => "rgb($red,$green,0)","stroke-width" => 6);#scale bar
#}
for(my $i=0;$i<=255;$i++){				#red2blue
	my $red = $redmin + $i;
	my $blue = $bluemax-$i;
	my $green = 200 - $i;
	$svg -> line(x1 =>$scalebarx ,y1 =>$scalebary-4*$i ,x2 =>$scalebarx+100 ,y2 =>$scalebary-4*$i ,stroke => "rgb($red,$green,$blue)","stroke-width" => 6);#scale bar
}
#for(my $i=0;$i<=255;$i++){				#green2blue
#	my $green = $greenmin + $i;
#	my $blue = $bluemax-$i;
#	$svg -> line(x1 =>$scalebarx ,y1 =>$scalebary-4*$i ,x2 =>$scalebarx+100 ,y2 =>$scalebary-4*$i ,stroke => "rgb(0,$green,$blue)","stroke-width" => 6);#scale bar
#}

my $textx=$scalebarx+10;
my $texty=$scalebary-1050;
$svg -> text(x => $textx ,y => $texty,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"R",'font-size' => 72,'font-weight'=>"bold",'font-style' => 'italic');
$svg -> text(x => $textx+60 ,y => $texty-40,"font-family" => "Arial","text-anchor" => "start","-cdata"=>"2",'font-size' => 48,'font-weight'=>"bold",'font-style' => 'italic');
$svg -> text(x => $textx+180 ,y => $scalebary-1000,"font-family" => "Arial","text-anchor" => "end","-cdata"=>"1",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => $textx+180 ,y => $scalebary-800,"font-family" => "Arial","text-anchor" => "end","-cdata"=>"0.8",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => $textx+180 ,y => $scalebary-600,"font-family" => "Arial","text-anchor" => "end","-cdata"=>"0.6",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => $textx+180 ,y => $scalebary-400,"font-family" => "Arial","text-anchor" => "end","-cdata"=>"0.4",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => $textx+180 ,y => $scalebary-200,"font-family" => "Arial","text-anchor" => "end","-cdata"=>"0.2",'font-size' => 48,'font-weight'=>"bold");
$svg -> text(x => $textx+180 ,y => $scalebary,"font-family" => "Arial","text-anchor" => "end","-cdata"=>"0",'font-size' => 48,'font-weight'=>"bold");



open(FILE,$ARGV[0]);
my %hash;
my %number;
my $header = <FILE>;
while(<FILE>){
	chomp;
	my @a=split(/\t/);
	my $key;
	if($a[3]<=$a[1]){
		$key = "$a[3]"."vs"."$a[1]";
	}else{
		$key = "$a[1]"."vs"."$a[3]";
	}
	$hash{$key} = $a[4];
	$number{$a[1]}=$a[1];
	$number{$a[3]}=$a[3];
}
my $totalSNP = keys %number;
my $unit_dis = 2000/$totalSNP;
my $unit_startx=200;
my $unit_starty=900;

my $row = 0;
for my $keys(sort{$a<=>$b} keys %number){
	my $col = 0;
	for my $keys2(sort{$a<=>$b} keys %number){
		if ($keys <= $keys2){
			my $posx = $unit_startx + $row*$unit_dis+1/2*$col*$unit_dis;
			my $posy = $unit_starty + 1/2*$col*$unit_dis;
			if($keys != $keys2){
				my $colorkey = $keys."vs".$keys2;
				my $colorvalue = $hash{$colorkey};
				my $red = int(255 * $colorvalue);
				my $blue = 255-$red;
				my $green = 200 - $red;
				$svg -> rectangle(x=> $posx,y=> $posy,width => 2000/$totalSNP/1.5,height=>2000/$totalSNP/1.5,'fill' => "rgb($red,$green,$blue)",'stroke-width' => 1,'stroke' => "black",transform => "rotate(45,$posx,$posy)");
				$col ++;
			}else{
				$svg -> rectangle(x=> $posx,y=> $posy,width => 2000/$totalSNP/1.5,height=>2000/$totalSNP/1.5,'fill' =>"black",'stroke-width' => 1,'stroke' => "black",transform => "rotate(45,$posx,$posy)");
				$col ++;

			}
		}
	}
	$row ++;
}

############output#######
my $result = $svg -> xmlify;
print $result;
