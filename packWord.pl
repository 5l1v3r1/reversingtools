#!/usr/bin/env perl
use warnings;
use strict;

sub packWord {
    my $encodedstr = "";
    foreach (split //, $_[0]) {
        $encodedstr .= unpack "H*", $_;
    }
    return lc($encodedstr);
}

while (<STDIN>){
    chomp(my $fullstr = $_);
    if (defined($ARGV[0]) and $ARGV[0] eq "-r"){
        $fullstr = reverse $fullstr;
    }
    $fullstr =~ s/\n//g;
    for (my $i=0; $i<length($fullstr); $i+=4){
        my $sstr = substr $fullstr, $i, 4;
        if (defined($ARGV[0]) and $ARGV[0] eq "-r"){
            $sstr = reverse $sstr;
        }
        print $sstr . ": 0x";
        $sstr = reverse $sstr;
        print packWord($sstr) . "\n";
    }
}
