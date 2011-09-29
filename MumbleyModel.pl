#!/usr/bin/perl

my $DICT;
my %dict;
open $DICT, "<dict.txt";
while(<$DICT>){

  chomp;
  my ($word,@phones) = split /\s+/;
  my $ph = join ' ', @phones;
  $dict{$word} = $ph;

}

my %model;
while(<>){

  chomp;
  $_ =~ s/"|'|:|;|,|\.|\(|\)|\[|\]|[1-9]//g;
  my @words = split /\s+/;
  my $wd;
  my @phones = ();
  foreach $wd(@words){
    push @phones, split /\s+/, $dict{$wd};
    push @phones, "~";
  }

  my $ph;
  my $last = undef;
  foreach $ph(@phones){
    if(!defined $last){
      $last = $ph;
      next;
    }

    if( exists $model{$last}->{$ph} ){
      $model{$last}->{$ph} += 1;
    }else{
      $model{$last}->{$ph} = 1;
    }
    $last = $ph;
      
  }
}

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

