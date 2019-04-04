open(IN, "N54_NCTC_strainNames");
while(<IN>){
    chomp;
    $count++;
    print "$count\t$_\n";
}

close(IN);

exit;
