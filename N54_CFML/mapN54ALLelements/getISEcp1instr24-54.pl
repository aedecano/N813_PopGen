open(PLUP, "pileup");
@plup = <PLUP>;
chomp(@plup);
for $str (@plup){
    open(IN, "$str");
#    open(OUT, ">./Res71CTM14coverage/$str-coverage.txt");
    #    print OUT "$str\n";
    print OUT  "Position\tCoverage\n";
    while(<IN>){
        chomp;
        @pileup = split/\t/,$_;
        for $e (0..$#pileup){}
        if ($pileup[1] >= 800 && $pileup[1] <= 3600 && $pileup[7] > 10){ #pctm14:874-1750
#           print "$pileup[3]";
            print OUT "$pileup[1]\t$pileup[7]\n"; #pCTM14 in Res7-1 coverage
        }
    }
    #    print "\n";
}

close(IN);

exit;
