$file = $ARGV[0];

open(IN, $file);
while(<IN>){
    chomp;
    @group = split/\t/,$_;
    for $g(0..$#group){}
    if ($group[1] =~ /Neg/){
        print "$group[0]\t#9ba1d8\tCOL#9ba1d8\n";
    }
    if ($group[1] =~ /Pos/){
       print "$group[0]\t#ff8000\tCOL#ff8000\n";
    }

}

close(IN);

exit;
