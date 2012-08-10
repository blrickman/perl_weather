#!/usr/local/bin/perl
use warnings;
use strict;
use v5.10;

use Getopt::Long;
use LWP::Simple;
use Tie::Array::CSV;

use weatheroptions;

my $date = '';
my $options = '';
my $wstation = 'KILCHICA114';

GetOptions(
  'history=s'  => \$date,
  'options'    => \$options,
  'wstation=s' => \$wstation,
);

my $website = "http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=$wstation&format=0";

if ($date) {
  if ($date =~ /^(\d{2})(\d{2})(\d{4})$/) {
    my ($month,$day,$year) = ($1,$2,$3);
    $website = "http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=$wstation&month=$month&day=$day&year=$year&format=0";
  } else {die 'Make sure date has correct MMDDYYYY format'}
}

my $weatherdata = get($website) or die 'Unable to get page. Make sure date is in MMDDYYYY format if using history option';

my $data = format_weather($weatherdata);

if ($options) {
  print "\nHere are the possible weather options to choose from:\n\n";
  for (keys %$data) {
  print "\t$_\n";
  }
  print "\n";
  exit;
}

say $$data{DateUTC}[0];

__END__
print "the heat index is " . heatindex($temp,relhum($temp,$dpt)) . "°F\nthe temperature is $temp°F\nrelative humidity is " . relhum($temp,$dpt) . "\%\n";
