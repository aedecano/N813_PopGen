open(IM, "Cfml_test2_rerun.output.importation_status.txt");
while(<IM>){
    chomp;
    if ($_ !~ /Beg|NODE/){
        @recom = split/\s+/,$_;
        for $r (0..$recom){}
#       system("samtools faidx blocks_Core_All_ST131.aln $recom[0]:$recom[1]-$recom[2] >> n813_allRecomTracts-extbranches.fasta");
    }
    if ($_ =~ /NODE/){
        @recom1 = split/\s+/,$_;
        for $r1 (@recom1){}
        system("samtools faidx blocks_Core_All_ST131.aln $recom1[0]:$recom1[1]-$recom1[2] >> n813_allRecomTracts-ancnode.fasta");
    }
}

close(IM);

exit;
