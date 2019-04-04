open(FILE, "N54NCTCemsim50.importation_status.txt") || die "Can't open $file3\n";

print FILE @finallist;

close(FILE);

# Routine to check for existance of an address.

sub find_in_store {
    $element = $ARGV[0];
    if (exists $elements{$ARGV[0]}) {
        print "$_";
    } else {
        return (0);
    }
}
