#perl -p -i -e 's/change this/to that/g' file1
open(IN, "allISEcp1-FA.txt");
while(<IN>){
    chomp;
    if ($_ =~ />/){
        @line = split/>/,$_;
        for $e (0..$#line){}
        $line[0] =~ s/.fasta://g;
        system("perl -p -i -e \'s\/$line[1]\/$line[0]\/g\' $line[0].fasta");
    }
}
close(IN);

exit;
