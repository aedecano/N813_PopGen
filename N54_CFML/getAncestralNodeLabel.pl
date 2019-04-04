##Trace ancestral node of ST131 strain in a given CfML tree

open (FILE, "Mancnode.txt") or die "$!\n";

my %hash;
while (my $line = <FILE>) {
    chomp($line);
    my ($key, $value) = split /\s+/, $line;
    $hash{$key} = $value;
}

open(IN, "N54_NCTC_strainNamesNumber");
while (my $col = <IN>){
    chomp($col);
    my ($key1, $value1) = split/\s+/, $col;
    $hash1{$key1} = $value1;
}


for my $branch (keys %hash) {
#    print "$key\n";
    if ($branch eq "\"$ARGV[0]\""){
#       print "$branch => $hash{$branch}\n";
        for my $num (keys %hash1){
            if ($num == $ARGV[0]){
                print "$hash1{$num} => $hash{$branch}\n";
            }
        }

    }
}


close(FILE);

close(IN);

exit;
