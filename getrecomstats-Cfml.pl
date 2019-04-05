#Extract and parse recombination parameters from Cfml log files
%Cfmlstats = (); #recombination parameters computed by Cfml
$log = "all813emsim50.perbranch.log.txt"; #standard model
print "###$log###\n";
open (IN, "$log");
while (<IN>){
    chomp;
    if ($_ =~ /Branch / && $_ !~ /NODE/){ #stats in external branches
#       &getstats;
    }
    elsif ($_ =~ /Branch / && $_ =~ /NODE/){ #stats in internal branches
        &getstats;
    }
    sub getstats {      @stats = split/\t/,$_;
                        for $s (@stats){
                            @branch = split/\s/,$s;
                            for $b (0..$#branch){}
                            @col = split/\s/,$branch[1];
                            for $c (@col){ #Branch/Node Label
                                $node = $c;
                            }
                            @col1 =split/\s/,$branch[4];
                            for $c1 (@col1){ #Uncorrected branch lengths
                                $brlen = $c1;
                            }
                            @col2 =split/\s/,$branch[7];
                            for $c2 (@col2){ #R/theta
                                $Rtheta = $c2;
                            }
                            @col3 =split/\s/,$branch[10];
                            for $c3 (@col3){ #delta
                                $delta = $c3;
                            }
                            @col4 =split/\s/,$branch[13];
                            for $c4 (@col4){ #mean divergence (nu)
                                $nu = $c4;
                            }
                            @col5 =split/\s/,$branch[16];
                            for $c5 (@col5){ #point mutations (m)
                                $mut = $c5;
                            }
                            $rec = $brlen*$Rtheta*$delta*$nu*$mut; #recombination
                            $rm = $rec/$mut; #recombination to mutation ratio
                            $node = "$node\t$brlen\t$Rtheta\t$delta\t$nu\t$rec\t$mut\t$rm";
                            $Cfmlstats{$node} = "recomstats";
                        }
    }
}
#print "###Recombination Parameters in External Branches###\n";
#print "###Recombination Parameters in Internal Branches###\n";
print "Branch_name\tUncorrected_branch_length\tR\/theta\tdelta(bp)\tnu\tRecombination(r)\tPoint_mutation(m)\tr\/m\n";
for $stats (sort keys %Cfmlstats){
    print "$stats\n";
}

close(IN);

exit;
