#!/usr/bin/perl -w

# Converts an ascii file in a binary (float32) file
# Usage: $0 ASCII_FILE BINARY_FILE

($txt,$bin) = @ARGV;
$exe=`basename $0`; chomp($exe);

if ($#ARGV != 1) {
  print STDOUT "+++ Error: missing or invalid arguments +++\n";
  print STDOUT "+++ Usage: $exe ASCII_FILE BINARY_FILE\n";
  die; exit;
}
unless (-e $txt) {
  print STDOUT "+++ Error: ascii input file $txt does not exist +++\n";
  print STDOUT "+++ Usage: $exe ASCII_FILE BINARY_FILE\n";
  die; exit;
}
if (-e $bin) {
#  print STDOUT "--- Warning: binary output file $bin exists ---\n";
#  print STDOUT "--- Warning: binary output file $bin will be deleted and replaced ---\n";
}

if (!(open(IN,"<$txt"))) {
  print STDOUT "+++ Error: cannot open in reading mode input file $txt +++\n";
  die; exit;
}
if (!(open(OUT,">$bin"))) {
  print STDOUT "+++ Error: cannot open in writing mode $bin +++\n";
  die; exit;
}
binmode(OUT);

while(!(eof(IN))) {
  $val_asc = <IN>; chomp($val_asc);
  $val_bin = pack('f',$val_asc);
  print OUT $val_bin;
}

close(IN);
close(OUT);

#print STDOUT "OK!!\n";
