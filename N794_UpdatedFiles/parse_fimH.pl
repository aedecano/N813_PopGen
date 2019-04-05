$file = $ARGV[0];

open(IN, $file);
while(<IN>){
    chomp;
    @group = split/\t/,$_;
    for $g(0..$#group){}
    if ($group[1] eq "fimH22"){
        print "$group[0]\t#bcd89b\tCOL#bcd89b\n";
    }
    if ($group[1] eq "fimH41"){
        print "$group[0]\t#9bd8d0\tCOL#9bd8d0\n";
    }
    if ($group[1] eq "fimH30"){
        print "$group[0]\t#0000ff\tCOL##0000ff\n";
    }
}

close(IN);

exit;
