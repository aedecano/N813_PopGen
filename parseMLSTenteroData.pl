$file = $ARGV[0];
open(IN, $file);
while(<IN>){
    chomp;
    if ($_ =~ /Uberstrain/){
        @head = split/\t/,$_;
        for $h (0..$#head){}
        print "$head[0]\t$head[1]\t";
        @seq = split/\;/,$head[2];
        for $s (0..$#seq){}
        $seq[0] =~ s/Data Source\(//g;
        print "$seq[0]\t$seq[1]\t$seq[2]\t$seq[3]\t$seq[4]\t";
        print "$head[3]\t$head[4]\t$head[5]\t$head[6]\t$head[7]\t$head[8]\t$head[9]\t$head[10]\t$head[11]\t$head[12]\t$head[13]\t$head[14]\t$head[15]\t$head[
16]\t$head[17]\t$head[18]\t$head[19]\t$head[20]\t$head[21]\t$head[22]\t$head[23]\t$head[24]\t$head[25]\t$head[26]\t$head[27]\t$head[28]\t$head[29]\t$head[30]
\t$head[31]\t$head[32]\t$head[33]\t$head[34]\t$head[35]\t$head[36]\n";
    }
    if ($_ !~ /Uberstrain/){
        @data = split/\t/,$_;
        for $d (0..$#data){}
        print "$data[0]\t$data[1]\t";
        @acc = split/\;/,$data[2];
        for $a (0..$#acc){}
        print "$acc[0]\t$acc[1]\t$acc[2]\t$acc[3]\t$acc[4]\t";
        print "$data[3]\t$data[4]\t$data[5]\t$data[6]\t$data[7]\t$data[8]\t$data[9]\t$data[10]\t$data[11]\t$data[12]\t$data[13]\t$data[14]\t$data[15]\t$data[
16]\t$data[17]\t$data[18]\t$data[19]\t$data[20]\t$data[21]\t$data[22]\t$data[23]\t$data[24]\t$data[25]\t$data[26]\t$data[27]\t$data[28]\t$data[29]\t$data[30]
\t$data[31]\t$data[32]\t$data[33]\t$data[34]\t$data[35]\t$data[36]\n";
    }
}


close(IN);

exit;
