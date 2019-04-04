##Run BLASTN
@c1strains = qw(79 33 59 35 2 51 75 26 43 41 49);
@c0strains = qw(3 27 60 52 57 73 50 58 74 25 34 42 37 76);
@c2strains = qw(77 24 48 22 39 1 53 78 30 85 95 61 55 9 45 40 87 86 46 29 56 23 54 31 47 96 32 38 5);

$ref = "ERR191724plasm_CTXM14";

system("makeblastdb -in $ref.fasta -dbtype nucl -out $ref.db -logfile $ref.log");
system("ls *_contigs.joined.fasta > in");

open(IN,"in");
while(<IN>){
    chomp;
    $_ =~ s/\_contigs.joined.fasta//;
    $x = $_;
    system("blastn -db $ref.db -query ${x}_contigs.joined.fasta -out $ref-${x}.crunch -outfmt 6");
}

close(IN);

#Parse crunch files from BLAST run: Res71CTM14 vs Contigs
$element = "IS"; #CTM14/15; #IS #mppA

system("head IS*crunch > ISEcp1inC0.txt");

open(CTM14, "ISEcp1inC0.txt");
while(<CTM14>){
    chomp;
    if ($_ =~ />/){
        @file = split/[==>,<==,".crunch",\s]+/,$_;
        for $f (0..$#file){}
#       print "$file[1]\n";
    }
    if($_ =~ /contigs/){
        @node = split/\t/,$_;
        for $n (0..$#node){}
        $node[0] =~ s/\_contigs.fasta//;
#       print "$node[0]\n";
#       print "$node[3]\n"; #segment length
#       print "$node[6]\n"; #start
#       print "$node[7]\n";
        $node[0]="$node[0]\t$node[3]\t$node[6]\t$node[7]";
        print "$node[0]\n";
    }
}

close(CTM14);

###For genoPlotR####
print "install.packages(\"genoPlotR\")\nlibrary(genoPlotR)\n\n";

##List strain number per clade according to their order in the tree
@c1strains = qw(79 33 59 35 2 51 75 26 43 41 49);
@c0strains = qw(3 27 60 52 57 73 50 58 74 25 34 42 37 76);
@c2strains = qw(77 24 48 22 39 1 53 78 30 85 95 61 55 9 45 40 87 86 46 29 56 23 54 31 47 96 32 38 5);

for $e2 (0..$#c1strains){
    $order1{$c1strains[$e2]}=$e2;
    $group{$c1strains[$e2]} = "c1";
}

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
    if($temp[1]>4000000){ $locus{$temp[0]}="chr"; }
    $mppa1{$temp[0]}=$temp[1]; # strain = start
    $mppa2{$temp[0]}=$temp[2]; # strain = end
} # end while # length = end-start so not required

for $e (sort $a <=> $b keys %order1){
    if($group{$e} eq "c1"){
        print "$e\n"; }
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
