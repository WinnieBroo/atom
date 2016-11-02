use 5.010;
use strict;
use warnings;
use Data::Dumper;
 
my $filename = 'perl.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
  
my @in_array;
my @array;
my $iter = 0;
my $tmp;
 
while (my $row = <$fh>) {
  chomp $row;
  $array[$iter] = [split (';', $row)];
} continue {
    $iter++};
 
print Dumper(@array);