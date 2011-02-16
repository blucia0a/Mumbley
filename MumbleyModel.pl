#!/usr/bin/perl

use warnings;
use strict;
use lib '/opt/local/lib/perl5/site_perl/5.8.9';
use lib '/opt/local/lib/perl5/5.8.9';
use HOP::Lexer 'make_lexer';

  
my @input_tokens = (

   [ 'SPACE',  qr/\s+/  ],

   [ 'ie', qr/ie/ ],
   [ 'i',  qr/i/  ],

   [ 'ee', qr/ee/ ],
   [ 'er', qr/er/ ],
   [ 'e',  qr/e/  ],

   [ 'ue', qr/ue/ ],
   [ 'u', qr/u/ ],
   
   [ 'air', qr/air/ ],  
   [ 'ae', qr/ae/ ],
   [ 'aa', qr/aa/ ],
   [ 'au', qr/au/ ],
   [ 'a', qr/a/ ],

   [ 'oe', qr/oe/ ],
   [ 'oo', qr/oo/ ],
   [ 'or', qr/or/ ],
   [ 'ou', qr/ou/ ],
   [ 'oi', qr/oi/ ],
   [ 'o', qr/o/ ],
   
   [ 'ssh', qr/ssh/ ],
   [ 'sh', qr/sh/ ],
   [ 'cch', qr/cch/ ],
   [ 'ch', qr/ch/ ],
   [ 'tthh', qr/tthh/ ],
   [ 'thh', qr/thh/ ],
   [ 'tth', qr/tth/ ],
   [ 'th', qr/th/ ],
   [ 'zzh', qr/zzh/ ],
   [ 'zh', qr/zh/ ],


   [ 'nn', qr/nn/ ],
   [ 'n', qr/n/ ],

   [ 'ss', qr/ss/ ],
   [ 's', qr/s/ ],

   [ 'tt', qr/tt/ ],
   [ 't', qr/t/ ],
   
   [ 'll', qr/ll/ ],
   [ 'l', qr/l/ ],
   
   [ 'kk', qr/kk/ ],
   [ 'k', qr/k/ ],
   
   [ 'dd', qr/dd/ ],
   [ 'd', qr/d/ ],
   
   [ 'rr', qr/rr/ ],
   [ 'r', qr/r/ ],
   
   [ 'zz', qr/zz/ ],
   [ 'z', qr/z/ ],
   
   [ 'pp', qr/pp/ ],
   [ 'p', qr/p/ ],
   
   [ 'mm', qr/mm/ ],
   [ 'm', qr/m/ ],
   
   [ 'gg', qr/gg/ ],
   [ 'g', qr/g/ ],
   
   [ 'bb', qr/bb/ ],
   [ 'b', qr/b/ ],
   
   [ 'ff', qr/ff/ ],
   [ 'f', qr/f/ ],
   
   [ 'yy', qr/yy/ ],
   [ 'y', qr/y/ ],
   
   [ 'vv', qr/vv/ ],
   [ 'v', qr/v/ ],
   
   [ 'ww', qr/ww/ ],
   [ 'w', qr/w/ ],
   
   [ 'jj', qr/jj/ ],
   [ 'j', qr/j/ ],
   
   [ 'hh', qr/hh/ ],
   [ 'h', qr/h/ ],

   [ 'aa', qr/[a-z]/ ],
   [ 'ao', qr/.*/ ],
         	                         
);       	                         


my @tokens;
my @text;
while(<>){

  chomp;
  push @text, lc $_;

}
  
  my $iter = sub { shift @text };
  my $lexer = make_lexer( $iter, @input_tokens );

  while ( my $token = $lexer->() ) {

    push @tokens, $token;

  }

my %model;
my $last = "";
foreach(@tokens){

  my $tok = ${$_}[0];
  if( $tok ne "SPACE" ){

    if( $last ne "" ){

      if( exists $model{$last}->{$tok} ){

        $model{$last}->{ $tok }++;

      }else{
        $model{$last}->{ $tok } = 1;

      }

      #print $tok;
      $last = $tok;

    }else{
      $last = $tok;
    } 

  }else{

    #print " ";
    $last = "";

  }

}
print "\n";

my %modelTotals;
my $k;
foreach $k(keys %model){
 
  print "$k\n"; 
  my $sum = 0;
  my $innerk;
  foreach $innerk(keys %{$model{$k}}){

    $sum += $model{$k}->{$innerk};
    
  }

  $modelTotals{$k} = $sum; 

  foreach $innerk(sort { $model{$k}->{$a} <=> $model{$k}->{$b} } keys %{$model{$k}}){
  
    print "\t$innerk->".($model{$k}->{$innerk} / $sum)."\n";

  }

}

exit(0);

my %sayMap;
$sayMap{"i"} = "it";
$sayMap{"ie"} = "i";
$sayMap{"e"} = "ehh";
$sayMap{"ee"} = "ee";
$sayMap{"er"} = "er";
$sayMap{"u"} = "uh";
$sayMap{"ue"} = "oo";
$sayMap{"ahe"} = "ahe";
$sayMap{"ae"} = "ey";
$sayMap{"ah"} = "ah";
$sayMap{"au"} = "aw";
$sayMap{"air"} = "air";
$sayMap{"oe"} = "o";
$sayMap{"oo"} = "oo";
$sayMap{"or"} = "or";
$sayMap{"ou"} = "ow";
$sayMap{"oi"} = "oy";

$sayMap{"sh"} = "sh";
$sayMap{"ssh"} = "sh";

$sayMap{"ch"} = "ch";
$sayMap{"cch"} = "ch";
$sayMap{"thh"} = "tha";
$sayMap{"tthh"} = "tha";
$sayMap{"th"} = "tha";
$sayMap{"tth"} = "tha";
$sayMap{"zh"} = "je";
$sayMap{"zzh"} = "je";

$sayMap{"n"} = "n";
$sayMap{"nn"} = "n";

$sayMap{"s"} = "s";
$sayMap{"ss"} = "s";

$sayMap{"t"} = "t";
$sayMap{"tt"} = "t";

$sayMap{"l"} = "l";
$sayMap{"ll"} = "l";
$sayMap{"k"} = "k";
$sayMap{"kk"} = "k";
$sayMap{"d"} = "d";
$sayMap{"dd"} = "d";
$sayMap{"r"} = "r";
$sayMap{"rr"} = "r";
$sayMap{"z"} = "z";
$sayMap{"zz"} = "z";
$sayMap{"p"} = "p";
$sayMap{"pp"} = "p";
$sayMap{"m"} = "m";
$sayMap{"mm"} = "m";
$sayMap{"g"} = "g";
$sayMap{"gg"} = "g";
$sayMap{"b"} = "b";
$sayMap{"bb"} = "b";
$sayMap{"f"} = "f";
$sayMap{"ff"} = "f";
$sayMap{"y"} = "y";
$sayMap{"yy"} = "y";
$sayMap{"v"} = "v";
$sayMap{"vv"} = "v";
$sayMap{"w"} = "w";
$sayMap{"ww"} = "w";
$sayMap{"j"} = "j";
$sayMap{"jj"} = "j";
$sayMap{"h"} = "h";
$sayMap{"hh"} = "h";





my $sent = "";
my $syl = "i";
while(1){

  if(exists $sayMap{$syl}){
    $sent .= $sayMap{$syl};
  }else{
    $sent .= $syl;
  }
  $syl = getRandomFollower($syl);

 # }else{

 #   my $n = rand(scalar keys %sayMap);
 #   $syl = (keys %sayMap)[$n];

 # }
  if( int(rand(7)) == 0 ){
    $sent .= " ";
  }
  
  if( int(rand(50)) == 0 ){
    $sent .= "\n";
    system("say -v whisper $sent");
    $sent = "";
  }
}




sub getRandomFollower(){

  my $k = shift;
  return "" if (!exists $modelTotals{$k});
  my $bound = rand($modelTotals{$k}) / $modelTotals{$k};

  my $runningTotal = 0;
  my $innerk;
  foreach $innerk(sort { $model{$k}->{$a} <=> $model{$k}->{$b} } keys %{$model{$k}}){
 
    $runningTotal += ($model{$k}->{$innerk} / $modelTotals{$k});
    if($runningTotal > $bound){
      return $innerk;
    }

  }

}


#k1 	n,nn 	7.8% 	in
#k2 	s,ss 	6.8% 	sin
#k3 	t,tt 	6.8% 	tip
#k4 	l,ll 	5.4% 	lift
#k5 	k,kk 	4.1% 	kid
#k6 	d,dd 	4.0% 	did
#k7 	r,rr 	3.9% 	rat
#k8 	z,zz 	3.7% 	zap
#k9 	p,pp 	3.3% 	pub
#k10 	m,mm 	3.0% 	mist
#k11 	g,gg 	2.6% 	good
#k12 	b,bb 	1.7% 	bad
#k13 	f,ff 	1.7% 	fair
#k14 	y,yy 	1.6% 	yet
#k16 	v,vv 	1.2% 	van
#k17 	w,ww 	1.2% 	wag
#k18 	j,jj 	0.8% 	just
#k19 	h,hh 	0.7% 	hat


#ID 	sound 	% 	Sample words

#v1 	i 	9.9% 	sit
#v9 	ie 	1.4% 	pie

#v5 	e 	2.6% 	beg
#v2 	ee 	5.0% 	see
#v3 	er 	3.4% 	her

#v4 	u 	3.3% 	up
#v12 	ue 	1.2% 	blue

#v6 	a 	2.1% 	bad
#v7 	ae 	2.1% 	sundae
#v8 	aa 	1.9% 	aardvark,Saab
#v14 	au 	0.4% 	auger
#v15 	air 	0.4% 	fair

#v10 	oe 	1.4% 	toe
#v11 	oo 	1.2% 	good
#v13 	or 	0.7% 	or
#v16 	ou 	0.4% 	out
#v17 	oi 	0.1% 	toil

#k15 	sh,ssh 	1.2% 	wish
#k20 	ch,cch 	0.5% 	chin
#k21 	thh,tthh 	0.3% 	thin
#k22 	th,tth 	0.1% 	that
#k23 	zh,zzh 	0.1% 	vision
