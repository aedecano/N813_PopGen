system("ls *rmdup* > in");
$program = "/usr/bin/samtools-0.1.11/samtools";
$ref = "Res7-1NODEwithplasmidCTM14.fasta";
open(IN, "in");
while(<IN>){
    chomp;
    $_ =~ s/.bam.sorted.bam.rmdup.bam//g;
    $x = $_;
#    print "$x\n";
    system("$program pileup -cf $ref $x.bam.sorted.bam.rmdup.bam > $x.pileup");
#    system("/usr/bin/samtools-0.1.11/misc/samtools.pl varFilter -W 7 -N 3 -D 5000 $x.pileup > $x.pileup.temp");
#    system("perl Iterate.pl $x.pileup.temp $x > $x.pileup.snp");
}


close(IN);

exit;
