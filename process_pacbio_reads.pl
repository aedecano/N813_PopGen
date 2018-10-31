##Quality control using Fastx toolkit, BayesHammer and FastQC (http://www.bioinformatics.babraham.ac.uk/projects/fastqc/). 
#module load bio
#module load fastx-toolkit/intel/0.0.14
#module load fastqc/0.10.1
#module load bioconductor/R/intel/2.14
#module load samtools/intel/0.1.19
#module load htslib
#module load sratoolkit
#module load prace/1.0 python
#module load py/intel/2.7.10
#module load spades/gcc/3.0.0

# Remove PCR primer sequences or reads < 50 bp and adapter seqs using fastx toolkit (http://hannonlab.cshl.edu/fastx_toolkit/index.html) 
#system ("fastq_quality_trimmer -t 30 -l 50 -i EC958.fastq -o EC958.trim.fastq -v > fastx.EC958.txt");
#system ("fastx_clipper  -Q 30  -a ATCTCTCTCTTTTCCTCCTCCTCCGTTGTTGTTGTTGAGAGAGAT -l 50  -i EC958.trim.fastq -o EC958.trim.clip.fastq –v > Summary.EC958.trim.txt");

##Correct and (de novo) assemble reads using BayesHammer from Spades package:
#system("spades.py --only-error-correction -s EC958.trim.clip.fastq -o Corrected_Reads/EC958");

##Rename and relocate corrected read libraries:
#system("mv Corrected_Reads/EC958/corrected/EC958.trim.clip.00.0_0.cor.fastq.gz  EC958_corrected.fastq.gz");
#system("gunzip EC958_corrected.fastq.gz");

##Run Fastqc on all processed libraries
#system("fastqc EC958_corrected.fastq");

##Compress or remove irrelevant files:
#system("unzip EC958_corrected_fastqc.zip");
#system("unzip EC958_corrected_fastqc.zip");
#system("rm -rf EC958_corrected_fastqc/I* EC958_corrected_fastqc/*html EC958_corrected_fastqc/summ* EC958_corrected_fastqc/*zip");

##Examine Fastqc output files:
#open (QC, ">>./QC_summary_stats.txt");
#Quality check of forward PE library##
#open IN2,"EC958_corrected_fastqc/fastqc_data.txt" or die "Can't read\n";
&check_qc;

#Quality check of reverse PE library##
#open IN2,"EC958_corrected_fastqc/fastqc_data.txt" or die "Can't read\n";
&check_qc;

sub check_qc {
    my @qcresult= <IN2>;
    chomp(@qcresult);
    $joined_lines = join("\n", @qcresult);
#       print "$joined_lines\n";
    @module = split/>>END_MODULE/,$joined_lines;
    chomp(@module);
    $number_mod = scalar(@module);
#       print "$number_mod\n"; #11 modules
    for $e (0..$#module){}
#####Basic Statistics##
    $QC{basic_stats} = "$module[0]";
    print QC "$QC{basic_stats}\n\n";

#####Basic Statistics: Check overall GC content##
    @basicStat = split/\n/,$module[0];
    for $bS (0..$#basicStat){}
#       print "$basicStat[3]\n";
    @library = split/\s+/,$basicStat[3];
    for $l (0..$#library){}
#       print "$library[1]\n";
    $library[1] =~ s/_out.fastq/ /g;
    @gc = split/\s+/,$basicStat[9];
    for $c (0..$#gc){}
#       print "$gc[1]\n";
    if ($gc[1] >= 50){
	print QC "The overall GC content of $library[1] is $gc[1] => Good library\n";
    }
    else {
	print QC "The overall GC content of $library[1] is below 50 => Bad library\n";
    }
#####Per base sequence quality##
    $QC{base_qual} = "$module[1]";
#       print QC "$QC{base_qual}\n\n";

#####Per sequence quality scores##
    $QC{seq_qual} = "$module[2]";
#       print "$QC{seq_qual}\n";

#####Per base sequence content##
#       $QC{seq_content} = "$module[3]";
#       print "$QC{seq_content}\n";
    @seqGC = split/\n+/,$module[5];
    for $s (@seqGC){
	if ($s =~ /[0-9]/){
	    @perseqGC = split/\s+/,$s;
	    for $ps (0..$#perseqGC){
		if ($perseqGC[0] >= 40 && $perseqGC[0] <= 75){
#                       print "$perseqGC[0]\t$perseqGC[1]\n";
		    @goodGC = split/\s+/,$perseqGC[1];
		    for $g (@goodGC){
			map { $sum += $g } @goodGC;
		    }
		}
		else {
#                       print "$perseqGC[0]\t$perseqGC[1]\n";
		    @badGC = split/\s+/,$perseqGC[1];
		    for $b (@badGC){
			map { $sum1 += $b } @badGC;
		    }
		}
	    }
	}
#       print "Total number of sequences with 40% to 75% GC content in $library[1]: $sum\n";
#       print "Total number of sequences with less than 45% and greater than 75% GC content in $library[1]: $sum1\n";
    }

#####Per base GC content##
    $QC{baseGC} = "$module[4]";
#       print "$QC{baseGC}\n";
    
#####Per sequence GC content##
    $QC{seqGC} = "$module[5]";
#       print "$QC{seqGC}\n";

#####Per base N content##
    $QC{baseN} = "$module[6]";
#       print "$QC{baseN}\n";
    
#####Sequence Length Distribution##
    $QC{length} = "$module[7]";
#       print "$QC{length}\n";
    
#####Sequence Duplication Levels##
    $QC{seqDup} = "$module[8]";
#       print "$QC{seqDup}\n";
}


#system("multiqc --force *_corrected_fastqc .");

#::Make a hash index “hash” for the reference genome::#                                                                                                                              
system ("smalt index -k 19 -s 1 NCTC13441-hash /ichec/work/dclif042c/COMP_ST131/FASTA_FILES/Escherichia_coli_UPEC_ST131_v0.2.fa");

#::Create an index .fai file to read hash::#                                                                                                                                         
system ("samtools faidx /ichec/work/dclif042c/COMP_ST131/FASTA_FILES/Escherichia_coli_UPEC_ST131_v0.2.fa");

#::Map the fastq reads (include both files) to make a SAM (samsoft)::#
system ("smalt map -f samsoft -x NCTC13441-hash EC958_corrected.fastq > EC958.sam"); 

#::Convert SAM to BAM with Samtools 
system ("samtools import NCTC13441.fa.fai EC958.sam EC958.bam");

#::Sort the BAM files::#
system ("samtools sort EC958.bam EC958.bam.sorted");

#::Index the BAM files::#
system ("samtools index EC958.bam.sorted.bam");

#::Remove PCR duplicate reads::#
system ("samtools rmdup EC958.bam.sorted.bam EC958.bam.sorted.bam.rmdup");

system("chmod 777 *");

close (IN2); #close fastqc_data files

exit;
