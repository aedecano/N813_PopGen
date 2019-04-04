#######Identify recombinant tracts and their lengths based on the importation status file
%tract = (); #recombinant tract coordinates and size in both internal and external branches
@IMPORT = glob("*importation*"); #read all importation status files
#    print "@IMPORT\n";
# Loop through multiple importation status files here
print "Number of recombinant blocks found in each branch\n";
foreach my $file (@IMPORT) {
    local $/ = undef;
    print "###$file###\n";
#    print "Branch_name\tStart\tEnd\tTract_length\n";
    open my $in, '<', $file;
    @text = <$in>;
#    print "@text\n";
    for $r (@text){
#       print "$r+++\n";
        @recom = split/\n/,$r;
        for $e (@recom){
            if ($e =~ /Beg/){ #get headers
#           print "$e+++\n";
            }
            else { #get tracts
                @block = split/\t/,$e;
                for $b (0..$#block){}
                $length = $block[2]-$block[1];
                $block[0] = "$block[0]\t$block[1]\t$block[2]\t$length";
                if ($block[0] !~ /NODE/){ #tracts in external branches
                    $c++;
#                   print "$block[0]\n";
                    $external = $block[0];
                    $tract{$external} = "Cfml";
                }
                else { #tracts in internal branches
                    $c1++;
#                   print "$block[0]\n";
                    $internal = $block[0];
                    $tract{$internal} = "Cfml";
                }
            }
        }
    }
    print "Branch\tCount\nExternal\t$c\nInternal\t$c1\n"; #Table summary of detected recom tracts in ex- and internal branches
}

for $ex (sort keys %tract){
    print "$ex\n"; #sorted recom file
}

close($in);

exit;
