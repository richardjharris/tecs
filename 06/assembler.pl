#!/usr/bin/perl

# Hack assembler
# Converts input (*.asm) to Hack output (*.hack)

use warnings;
use strict;
use Readonly;

# Computation destinations, in same order as the bits in the instruction
Readonly my @DESTS = qw(A D M);

# Mapping of jump mnemonics to bitcodes
Readonly my %JUMP = (
  ''  => '000',
  JGT => '001',
  JEQ => '010',
  JGE => '011',
  JLT => '100',
  JNE => '101',
  JLE => '110',
  JMP => '111',
);

# Mapping of computations to bitcodes ('M' can be used in place of 'A')
Readonly my %COMP = (
  '0' => '101010',
  '1' => '111111',
  '-1' => '111010',
  'D' => '001100',
  'A' => '110000',
  '!D' => '001101',
  '!A' => '110001',
  '-D' => '001111',
  '-A' => '110011',
  'D+1' => '011111',
  'A+1' => '110111',
  'D-1' => '001110',
  'A-1' => '110010',
  'D+A' => '000010',
  'D-A' => '010011',
  'A-D' => '000111',
  'D&A' => '000000',
  'D|A' => '010101',
);

# Symbol table, with default entries.
my %SYM = (
  SP => 0,
  LCL => 1,
  ARG => 2,
  THIS => 3,
  THAT => 4,
  SCREEN => 16_384,
  KBD => 24_576,
);
$SYM{"R$_"} = $_ for (0..15);

# Where to place the next new variable
my $next_variable = 16;

my @I; # Instructions

my $pos = 0;
my $dangling = 0;
while (<>) {
    chomp;
    s{//.*$}{};  # comments
    s{^\s*}{};   # whitespace
    s{\s*$}{};
    next if $_ eq '';
    
    if (/^\((.*?)\)$/) {
        # symbol
        my $sym = $1;
        die "Symbol '$sym' already declared"
            if exists $SYM{$sym};
        $SYM{$sym} = $pos;
        $dangling = 1;
    }
    else {
        push @I, [$., $_];
        $pos++;
        $dangling = 0;
    }
}

die "Final symbol does not have an instruction"
    if $dangling;

# Convert @I into machine code
foreach (@I) {
    my ($lineno, $inst) = @$_;
    local $. = $lineno;
    if ($inst =~ /^@/) {
        # A-instruction
        my $address = substr $inst, 1;
        if ($address !~ /^[0-9]+$/) {
            my $symbol = $address;
            $address = $SYM{$symbol};
            if (!defined $address) {
                # Create a new variable
                $address = $next_variable++;
                $SYM{$symbol} = $address;
            }
        }
        if ($address > 2**16 - 1) {
            die "Value '$address' too big!";
        }
        if ($address < 0) {
            die "Value '$address' is negative!";
        }
        
        # Convert address to bits and output
        print sprintf('%016b', $address), "\n";
    }
    elsif ($inst =~ m{^(?:(.*?)\=)? (.*?) (?:;(.*))?$}x) {
        # C-instruction
        my ($dest, $comp, $jump) = ($1, $2, $3);
        my $aflag = 0;
        $dest = '' if !defined $dest;
        $jump = '' if !defined $jump;
        die "Invalid syntax for '$inst' (no computation?)" if $comp eq '';
        
        # Resolve mnemonics into bitcodes
        my $jumpcode = $JUMP{$jump};
        die "Invalid jump conditional '$jump'" if !defined $jumpcode;
        
        my $compcode = $COMP{$comp};
        if (!defined $compcode) {
            # Try again with M -> A
            my $comp2 = $comp;
            $comp2 =~ s/M/A/g;
            $compcode = $COMP{$comp2};
            $aflag = 1;
        }
        die "Invalid computation '$comp'" if !defined $compcode;
        
        # We are slightly flexible and allow A/M/D in any order (or repeated)
        die "Invalid destination '$dest'" if $dest !~ /^[AMD]*$/;
        my $destcode = join '', map { $dest =~ /$_/ ? '1' : '0' } @DESTS;
        
        # Output
        print join('', '111', $aflag, $compcode, $destcode, $jumpcode), "\n";
    }
    else {
        die "Invalid instruction '$inst'";
    }
}
