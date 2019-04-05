open(TR, $ARGV[0]); #"AB.output.labelled_tree.newick");
while(<TR>){
    chomp;
    @clade = split/NODE_[0-9]/,$_;
    for $c (@clade){
        print "$c++\n\n";
    }
}

close(TR);

exit;
