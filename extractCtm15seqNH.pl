open(IN, "CTM15strainsFromCath-NH.txt");
while(<IN>){
    chomp;
    if ($_ =~ /home/){
        @nh = split/\t+/,$_;
        for $e (0..$#nh){}
#       print "$nh[0]\n";
        system("samtools faidx blocks_Core_All_ST131.aln.fasta $nh[0]");
    }
}

close(IN);

exit;
