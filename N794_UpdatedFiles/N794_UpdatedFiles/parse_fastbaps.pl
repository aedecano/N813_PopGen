$file = $ARGV[0];

open(IN, $file);
while(<IN>){
    chomp;
    @group = split/\t/,$_;
    for $g(0..$#group){}
    if ($group[1] == 1){
        print "$group[0]\t#ff0038\tCOL#ff0038\n";
    }
    if ($group[1] == 2){
        print "$group[0]\t#0000ff\tCOL#0000ff\n";
    }
    if ($group[1] == 3){
        print "$group[0]\t#008000\tCOL#008000\n";
    }
    if ($group[1] == 4){
        print "$group[0]\t#9400d3\tCOL#9400d3\n";
    }
    if ($group[1] == 5){
        print "$group[0]\t#ffff00\tCOL#ffff00\n";
    }
    if ($group[1] == 6){
        print "$group[0]\t#ff8000\tCOL#ff8000\n";
    }
    if ($group[1] == 7){
        print "$group[0]\t#26ff00\tCOL#26ff00\n";
    }
    if ($group[1] == 8){
        print "$group[0]\t#ff009e\tCOL#ff009e\n";
    }
    if ($group[1] == 9){
        print "$group[0]\t#9ba1d8\tCOL#9ba1d8\n";
    }
    if ($group[1] == 10){
        print "$group[0]\t#bc9bd8\tCOL#bc9bd8\n";
    }
    if ($group[1] == 11){
        print "$group[0]\t#bcd89b\tCOL#bcd89b\n";
    }
    if ($group[1] == 12){
        print "$group[0]\t#9bd8d0\tCOL#9bd8d0\n";
    }
    if ($group[1] == 13){
        print "$group[0]\t#0beacd\tCOL##0beacd\n";
    }
    if ($group[1] == 14){
        print "$group[0]\t#ea460b\tCOL#ea460b\n";
    }
    if ($group[1] == 15){
        print "$group[0]\t#aaaaaa\tCOL#aaaaaa\n";
    }
    if ($group[1] == 16){
        print "$group[0]\t#000000\tCOL#000000\n";
    }
    if ($group[1] == 17){
        print "$group[0]\t#7300d3\tCOL#7300d3\n";
    }
    if ($group[1] == 18){
        print "$group[0]\t#d300cd\tCOL#d300cd\n";
    }
    if ($group[1] == 19){
        print "$group[0]\t#11731d\tCOL#11731d\n";
    }
    if ($group[1] == 20){
         print "$group[0]\t#d39500\tCOL#d39500\n";
    }
    if ($group[1] == 21){
        print "$group[0]\t#1f00d3\tCOL#1f00d3\n";
    }
    if ($group[1] == 22){
        print "$group[0]\t#084729\tCOL#084729\n";
    }
    if ($group[1] == 23){
        print "$group[0]\t#f0cad5\tCOL#f0cad5\n";
    }
}

close(IN);

exit;
