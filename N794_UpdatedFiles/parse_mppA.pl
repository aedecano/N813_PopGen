$file = $ARGV[0];

open(IN, $file);
while(<IN>){
    chomp;
    @group = split/\s/,$_;
    for $g(0..$#group){}
    if ($group[1] eq "I"){
        print "$group[0]\t#0beacd\tCOL#0beacd\n";
    }
    if ($group[1] eq "T"){
        print "$group[0]\t#0000ff\tCOL#0000ff\n";
    }
}

close(IN);

exit;
