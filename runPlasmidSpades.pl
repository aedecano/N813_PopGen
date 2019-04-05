$file = $ARGV[0];
open(IN, $file);
while(<IN>){
    chomp;
    $x = $_;
    system("/media/newdrive/arun/MinIONdata_Sanger/1stRunMinION/ConcatFQtrim_porechop/SPAdes-3.12.0-Linux/bin/spades.py --plasmid -1 $x\_1.fastq.gz -2 $x\_2.
fastq.gz -o /media/newdrive/arun/N813_Analysis/N62_plasmidSpadesOUT/MissingData/$x\_plasmidSpadesOUT");
}


close(IN);

exit;
