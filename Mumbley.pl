#!/usr/bin/perl

use warnings;
use strict;

use lib '/opt/local/lib/perl5/site_perl/5.8.9';
use lib '/opt/local/lib/perl5/5.8.9';
use WWW::Mechanize;

my $wordMax = 400;
my $currentString = "";
my $wordCount = 0;

while(<>){

  my $line = $_;
  chomp $line;
  my @words = split /\s+/, $line;
  $wordCount += $#words;
  $currentString .= $line;

  if($wordCount >= $wordMax){
    &getPhoenetic($currentString);
    $wordCount = 0;
    $currentString = "";
    sleep(5);
  }


}



sub getPhoenetic(){

  #Must POST
  #textbox is called "termbox"
  #input type="submit" has value "Convert" and name "B1"
  my $ts_url = "http://www.foreignword.com/cgi-bin//transpel.cgi";
  my $curStr = shift;
  #print "GOT $curStr\n";
  my $ua = WWW::Mechanize->new;
  $ua->get( $ts_url );
  $ua->submit_form( fields => { termbox => $curStr } );
  print $ua->content;

}
