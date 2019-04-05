$file = $ARGV[0];

open(IN, $file);
while(<IN>){
    chomp;
    @group = split/\t/,$_;
    for $g(0..$#group){}
    if ($group[1] =~ /Aus/){
        print "$group[0]\t#d300cd\tCOL#d300cd\n"; #red violet
    }
    if ($group[1] =~ /Can/){
        print "$group[0]\t#084729\tCOL#084729\n"; #blackish green
    }
    if ($group[1] =~ /Ind/){
        print "$group[0]\t#000000\tCOL#000000\n";
    }
    if ($group[1] =~ /Ireland/){
        print "$group[0]\t#ff009e\tCOL#ff009e\n"; #pink/fuschia
    }
    if ($group[1] =~ /Korea/){
        print "$group[0]\t#aaaaaa\tCOL#aaaaaa\n";
    }
    if ($group[1] =~ /NZ/){
        print "$group[0]\t#26ff00\tCOL#26ff00\n"; #neon green
    }
    if ($group[1] =~ /Port/){
        print "$group[0]\t#0beacd\tCOL#0beacd\n"; #ocean
    }
    if ($group[1] =~ /Spain/){
       print "$group[0]\t#0000ff\tCOL#0000ff\n";
    }
    if ($group[1] eq "UK" | $group[1] eq "United Kingdom"){
    print "$group[0]\t#d39500\tCOL#d39500\n"; #mandarin orange
    }
    if ($group[1] =~ /USA/){
        print "$group[0]\t#ffff00\tCOL#ffff00\n"; #yellow
    }
}

close(IN);

exit;
