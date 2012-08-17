#!/usr/bin/perl

use warnings;
use strict;

sub format_weather {
  my ($wdata,$format) = (shift, shift);

  my @warray = split /<br>/, $wdata;
  pop @warray; #empty string at end
  die 'No data at website, check Date and/or Weather Station.' unless $warray[1];

  for (@warray) {
    s/,$//;
    s/^\n//;
  }

  for my $j (0..@warray-1) {
    my $i = 1;
    while ($i) {
      $i = chomp $warray[$j];
    }

    my @temp = split /,/, $warray[$j];
    $warray[$j] = \@temp;
  }
  $wdata = \@warray;
  return $wdata if $format;
  my %whash;
  for my $i (0..@{@$wdata[0]}-1) {
    my @temp;
    for my $j (1..@$wdata-1) {
      unshift @temp, $$wdata[$j][$i];
    }
    $whash{$$wdata[0][$i]} = \@temp;
  }
  return \%whash;
}

sub heatindex {
  my ($temp,$rh,$coef) = @_;
  my @hi_c = (-42.38, 2.049, 10.14, -.2248, -6.838E-3, -5.482E-2, 1.228E-3, 8.528E-4, -1.99E-6);
  @hi_c = qw/0.363445176 0.988622465 4.777114035 -0.114037667 -0.000850208 -0.020716198 0.000687678 0.000274954 0/ if $coef;
  my @hi_tr = (1, $temp, $rh, $temp*$rh, $temp**2, $rh**2, $temp**2*$rh, $temp*$rh**2, $temp**2*$rh**2);
  my $hi;
  for (0..@hi_c-1) {
    $hi += $hi_c[$_]*$hi_tr[$_];
  }
  return sprintf("%.1f",$hi)
}

sub relhum {
  my ($temp,$dpt) = @_;
  return sprintf("%.0f",(100*((112-.1*tocels($temp)+tocels($dpt))/(112+.9*tocels($temp)))**8));
}

sub tocels { 5*(shift()-32)/9 }

1;
