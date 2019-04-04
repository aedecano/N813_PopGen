$countUniqNode = 'grep "NODE" *.importation_status.txt | awk \'{print $1}\' | uniq | wc -l';
print "Number of shared nodes found:\t";
system("$countUniqNode");
$UniqNodeNumber = 'grep "NODE" *.importation_status.txt | awk \'{print $1}\' | uniq';
print "Shared nodes label:\n";
system("$UniqNodeNumber");

###Nodes found: NODE_59 NODE_60 NODE_61 NODE_62 NODE_68 NODE_94 NODE_96 NODE_97 NODE_98 NODE_99 NODE_100 NODE_101 NODE_102 NODE_107

###To run this script: perl getSharedNodes.pl <<Prefix of importation file>> <<Node # (i.e. 59)>> <<Press Enter 2x>>

<STDIN>;

print "Branch\tRecomStart\tRecomEnd\tRecomLength(bp)\n";

open(IN, "$ARGV[0].importation_status.txt");
@import = <IN>;
chomp(@import);
for $i (@import){
    if ($i !~ /Beg/){
        if ($i =~ /NODE_$ARGV[1]/){
            @node = split/\s+/,$i;
            for $n (0..$#node){}
            $beg = $node[1];
            $end = $node[2];
            $len = $node[2] - $node[1];
            print "ANC_$ARGV[1]\t$beg\t$end\t$len\n";
        }
        if ($i =~ /$ARGV[2]/){
            @node1 = split/\s+/,$i;
            for $n1 (0..$#node1){}
            $beg1 = $node1[1];
            $end1 = $node1[2];
            $len1 = $node1[2] - $node1[1];
            print "$beg1\t$end1\t$len1\n";
        }
    }
}


close(IN);


exit;
