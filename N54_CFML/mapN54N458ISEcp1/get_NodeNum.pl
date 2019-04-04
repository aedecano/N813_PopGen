###Extract info about mppA in the N=54 contigs###
print "###ISEcp1###\n";
#NODE_19_length_108919_cov_12.6234_ID_37 AB683464.1:932-2586     100.00  1203    0       0       1       1203    1203    1       0.0     2222
@str = qw(#49 #79 #51 #27 #9 #24 #86 #77 #47 #54 #5 #56 #38 #61 #96 #95 #39 #58 #41 #35 #60 #2 #57 #59 #37 #50 #42 #52 #25 #73 #43 #33 #74 #76 #34 #3 #26 #75
 #85 #31 #46 #78 #55 #32 #23 #87 #30 #48 #29 #22 #53 #45 #40 #1);
for $str (@str){
#    print "8289_1$str\t";
open(IN, "8289_1$str-ISEcp1.out");
while (<IN>){
    chomp;
    if ($_ =~ /NODE/){
        @contig = split/\_/,$_;
        for $c (0..$contig){}
#       print "$contig[1]\n";
        @line = split/\s/,$_;
        for $l (0..$#line){}
#       print "$line[3]\n"; #length
#       print "$line[6]\t$line[7]\n"; #start-end contig
        $info = "$contig[1]\t$line[6]\t$line[7]\t$line[3]";
#       print "$info\n";
        if ($line[8] > $line[9]){
            print "8289_1$str\t$line[3]\tREVERSE\n";
        }
        else {
            print "8289_1$str\t$line[3]\tFWD\n";
        }
    }
}
}
close(IN);

exit;
