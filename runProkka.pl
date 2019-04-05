$file = $ARGV[0];
open(IN, $file);
while(<IN>){
    chomp;
    $x = $_;
    system("prokka --outdir ${x}_prokka_out --prefix ${x}_prokka /media/newdrive/arun/SCRAPER_ST131/Raw_FQs/Illumina-HiSeq/SRSbreaks/Contigs_unicycler/${x}_c
ontigs.fasta");
}

close(IN);

exit;
