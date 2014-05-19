#!/usr/bin/perl

use warnings;
use strict;
use lib '/opt/local/lib/perl5/site_perl/5.8.9';
use lib '/opt/local/lib/perl5/5.8.9';
use List::Util "shuffle";

my %model;
my %modelTotals; 

&getModel($ARGV[0]);

my $sent = "";
my ($syl) = shuffle keys %model;


while(1){

  $sent .= $syl;

  $syl = &getRandomFollower($syl);

  if( $syl eq "~" ){ #every 7 syllables or so break a word
    $sent .= " ";
  }
  
  if( int(rand(50)) == 0 ){ #every 50 syllables or so (7-8 words) break a line, and say it.
    $sent .= "\n";
    print $sent;
    $sent = "";
  }

}


sub getRandomFollower(){

  my $k = shift;
  my $bound = rand();

  my $innerk;
  foreach $innerk(sort { $model{$k}->{$a} <=> $model{$k}->{$b} } keys %{$model{$k}}){
    $bound -= $model{$k}->{$innerk};
    #print "$bound: $innerk (".$model{$k}->{$innerk}.")\n";
  
    if($bound <= 0){
      #print "<<<<$innerk>>>>\n";
      return $innerk;
    }

  }
  warn "No $innerk\n";

}

sub getModel(){

  my $modelFile = shift;

  my $curLetter = "";
  my $FILE;
  open $FILE,"<$modelFile" or die "$!: Couldn't open file $modelFile\n";
  while(<$FILE>){

    chomp;
    
    if(/^[a-zA-Z1-9_\~]/){
      s/[^a-zA-Z1-9_\~]//g;
      $curLetter = $_;

    }elsif(/[a-zA-Z1-9_\~]/){

      my ($let,$freq) = split /->/;
      $let =~ s/[^a-zA-Z1-9_\~]//g;
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
