#!/usr/bin/perl

use warnings;
use strict;
use lib '/opt/local/lib/perl5/site_perl/5.8.9';
use lib '/opt/local/lib/perl5/5.8.9';

my %model;
my %modelTotals; 
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

&getModel($ARGV[0]);



my $sent = "";
my $syl = "i";
while(1){

  if(exists $sayMap{$syl}){
    $sent .= $sayMap{$syl};
  }else{

    $sent .= $syl;
  }
  $syl = &getRandomFollower($syl);

  if( int(rand(5)) == 0 ){ #every 7 syllables or so break a word
    $sent .= " ";
  }
  
  if( int(rand(50)) == 0 ){ #every 50 syllables or so (7-8 words) break a line, and say it.
    $sent .= "\n";
    #system("say -v whisper $sent");
    print $sent;
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

sub getModel(){
  my $modelFile = shift;

  my $curLetter = "";
  my $FILE;
  open $FILE,"<$modelFile" or die "$!: Couldn't open file $modelFile\n";
  while(<$FILE>){

    chomp;
    
    if(/^[a-z]/){
      s/[^a-z]//g;
      $curLetter = $_;

    }elsif(/[a-z]/){

      my ($let,$freq) = split /->/;
      $let =~ s/[^a-z]//g;
      $model{$curLetter}->{$let} = $freq;
      if(exists $modelTotals{$curLetter}){
        $modelTotals{$curLetter} += $freq;
      }else{
        $modelTotals{$curLetter} = $freq;
      }

    }
  }
  close $FILE;
}

sub printModel(){

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
}
