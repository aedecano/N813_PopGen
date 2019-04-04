# Don't use arrays!
# Read everything into a hash

print "install.packages(\"genoPlotR\")\nlibrary(genoPlotR)\n\n";

##List strain number per clade according to their order in the tree
@c1strains = qw(79 33 59 35 2 51 75 26 43 41 49);
@c0strains = qw(3 27 60 52 57 73 50 58 74 25 34 42 37 76);
@c2strains = qw(77 24 48 22 39 1 53 78 30 85 95 61 55 9 45 40 87 86 46 29 56 23 54 31 47 96 32 38 5);

open $ct, '<', 'ctm14-C1.txt' or die $!; #file containing ctm coordinates
while(<$ct>){ # read in CTX-M
    chomp;
    @temp = split/\t/,$_; #split ctm file per column
    $ctm1{$temp[0]}=$temp[1]; # strain = CTX-M start
    $ctm2{$temp[0]}=$temp[2]; # strain = CTX-M end
} # end while

open $mp, '<', 'mppA-C1.txt' or die $!; #file containing mppA coordinates
while(<$mp>){ # read in mppa
    chomp;
    @temp = split/\t/,$_; #split mppa file per column
    $mppa1{$temp[0]}=$temp[1]; # strain = start
    $mppa2{$temp[0]}=$temp[2]; # strain = end
} # end while # length = end-start so not required

for $e (sort keys %ctm1){
#    print "$e => $ctm1{$e},$ctm2{$e} length=",($ctm2{$e}-$ctm1{$e}+1)," $mppa1{$e},$mppa2{$e} length=",($mppa2{$e}-$mppa1{$e}+1),"\n";
    print "names-$e <- c(\"mppA\", \"CTX-M\")\n";
    print "starts-$e <- c($mppa1{$e},$ctm1{$e})\n"; # syntax in the genoPlotR script (start)
    print "ends-$e <- c($mppa2{$e},$ctm2{$e})\n"; #syntax in the genoPlotR script (end)
    print "strands-$e <- c(1, 1)\n";
    print "cols-$e <- c(\"green\", \"violet\")\n";
    print "df-$e <- data.frame(name=names-$e, start=starts-$e, end=ends-$e, strand=strands-$e, col=cols-$e)\n";
    print "dna_seg-$e <- dna_seg(df-$e)\n";
    print "str(dna_seg-$e)\n\n\n";
}

print "dna_segs <- list(";
print ")\nplot_gene_map(dna_segs=dna_segs)\n";

close($ct);
close($mp);

exit;
