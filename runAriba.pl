open(IN, "in");
while(<IN>){
    chomp;
    $x = $_;
    $x =~ s/.fasta//g;
    system("ariba prepareref --force --all_coding yes -f ${x}.fasta out.${x}.prepareref");
    system("ariba run out.${x}.prepareref  8289_1#64_1.fastq 8289_1#64_2.fastq  Str64_${x}_OUT ");
    system("ariba summary Str64_${x}_OUT Str64_${x}_OUT/${x}_report.tsv");
}

close(IN);

exit;
