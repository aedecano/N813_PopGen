$file = $ARGV[0];

open(IN, $file);
while(<IN>){
    chomp;
    if ($_ !~ /NEXUS|begin/){
        @strains = split/,|:|=/,$_;
        for $s (@strains){
            $s =~ s/\(//g;
            $s =~ s/\)//g;
            $s =~ s/\[&R\]//g;
            if ($s =~ /\_/ && $s !~ /NODE/ && $s !~ /tree/ ){
                print "$s\n";
            }
        }
    }
}

close(IN);

exit;
