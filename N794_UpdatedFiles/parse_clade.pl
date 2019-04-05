$file = $ARGV[0];

open(IN, $file);
while(<IN>){
    chomp;
    @group = split/\t/,$_;
    for $g(0..$#group){}
    if ($group[1] eq "A"){
        print "$group[0]\t#bcd89b\tCOL#bcd89b\n";
    }
    if ($group[1] eq "B"){
        print "$group[0]\t#9bd8d0\tCOL#9bd8d0\n";
    }
    if ($group[1] eq "C"){
        print "$group[0]\t#0beacd\tCOL##0beacd\n";
    }
    if ($group[1] eq "C1"){
        print "$group[0]\t#008000\tCOL#008000\n";
    }
    if ($group[1] eq "C2"){
        print "$group[0]\t#7300d3\tCOL#7300d3\n";
    }
    if ($group[1] eq "B0"){
        print "$group[0]\t#ffff00\tCOL#ffff00\n";
    }
    if ($group[1] eq "C0"){
#        print "$group[0]\t#ea460b\tCOL#ea460b\n";
    }
    if ($group[1] eq "C3"){
#        print "$group[0]\t#9ba1d8\tCOL#9ba1d8\n";
    }
    if ($group[1] eq "C0_1"){
#       print "$group[0]\t#ff8000\tCOL#ff8000\n";
    }

}

close(IN);

exit;
