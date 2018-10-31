##Quality control using FastQC (http://www.bioinformatics.babraham.ac.uk/projects/fastqc/). 
#module load bio
#module load fastqc/0.10.1
#module load samtools/intel/0.1.19
#module load prace/1.0 python
#module load py/intel/2.7.10
#module load spades/gcc/3.0.0

if(length($score)>0){  $score = $ARGV[0];  } else { $score = 30;  }  # 30
if(length($window)>0){ $window = $ARGV[1]; } else { $window = 10; }  # 10
if(length($length)>0){ $length = $ARGV[2]; } else { $length = 50; }  # 50

system("ls *_1.fastq.gz > in "); # read in FASTQ files

system("mkdir Trimmo_logs"); #Save trimmo logs here
system("mkdir Corrected_Reads"); #save corrected reads here

open(IN,"in"); # open FASTQ file list

while(<IN>){ 
    chomp;
    $x = $_; 
    $x =~ s/\_1\.fastq\.gz//g;
    $x2 = $x;

# Quality trimming to remove low quality bases at 3’ end of reads with a quality score < 30 or reads < 95 bases in length using Trimmomatic
	##Run trimmomatic on PE reads:
	# Remove adapters all.fasta:2:30:10; adapter seq are saved in the specified folder 
# Remove leading low quality or N bases (below quality $score) (LEADING:$score)
# Remove trailing low quality or N bases (below quality $score) (TRAILING:$score)
# Scan the read with a sliding window, cutting when the average quality per base drops below $score (SLIDINGWINDOW:$window:$score)
# Drop reads below $length bases long (MINLEN:$length)

    system("java -jar /usr/bin/Trimmomatic-0.36/trimmomatic-0.36.jar PE -phred33 ${x2}_1.fastq.gz ${x2}_2.fastq.gz ${x2}_1_out.fastq.gz ${x2}_1_unpaired.fastq.gz ${x2}_2_out.fastq.gz ${x2}_2_unpaired.fastq.gz ILLUMINACLIP:/usr/bin/Trimmomatic-0.36/adapters/all.fa:2:30:10 LEADING:${score} TRAILING:${score} SLIDINGWINDOW:${window}:${score} MINLEN:${length} &> Trimmo_logs/${x2}.log");
    system("gunzip ${x2}_1_out.fastq.gz ${x2}_2_out.fastq.gz");
#Process log files from Trimmomatic runs
    open(LOG, ">./Trimmo_logs/trimmo_summary.txt");
    %trimmoLog = ();
    print LOG "SRA_ID\tInput_Reads\tPaired_reads-count\tPaired_reads-percent\tForward_only_reads-count\tForward_only_reads-percent\tReverse_only_reads-count\tReverse_only_reads-percent\tDropped_reads-count\tDropped_reads-percent\n";
    @FILES = glob("Trimmo_logs/*.log");
#    print "@FILES\n";
# Loop through multiple log files here
    foreach my $file (@FILES) {
	local $/ = undef;
	open my $fh, '<', $file;
	@trimmed = <$fh>;
	for $t (@trimmed){
	    @log = split/\n/,$t;
	    for $e (@log){
		if ($e =~ /-phred33/){
		    @cmd = split/_1.fastq.gz/,$e;
		    for $c (0..$#cmd){}
		    @id = split/ -phred33 /,$cmd[0];
		    chomp;
		    for $i (0..$#id) {}
#               print "$id[1]\t"; #SRA ID
		}
		if ($e =~ /Input/){
		    @stats = split/:+/,$e;
#               $num = scalar(@stats);
#               print "$num\n";
		    for $st (0..$#stats){}
		    @input = split/Both/,$stats[1];
		    for $i (0..$#input){}
#               print "$input[0]\t"; #Number of input reads
		    @paired = split/\(+|\)+|\%+/,$stats[2];
		    for $p (0..$#paired){}
#               print "$paired[0]\t"; #Number of paired reads
#               print "$paired[1]\t"; #Percent paired reads
		    @forward = split/\(+|\)+|\%+/,$stats[3];
		    for $f (0..$#forward){}
#               print "$forward[0]\t"; #Number of forward only reads
#               print "$forward[1]\t"; #% forward only reads
		    @reverse = split/\(+|\)+|\%+/,$stats[4];
		    for $r (0..$#reverse){}
#               print "$reverse[0]\t"; #Number of reverse only reads
#               print "$reverse[1]\t"; #% reverse only reads
		    @dropped = split/\(+|\)+|\%+/,$stats[5];
		    for $d (0..$#dropped){}
#               print "$dropped[0]\t"; #Number of dropped reads
#               print "$dropped[1]\n"; #% dropped reads
		    $id[1] = "$id[1]\t$input[0]\t$paired[0]\t$paired[1]\t$forward[0]\t$forward[1]\t$reverse[0]\t$reverse[1]\t$dropped[0]\t$dropped[1]";
		    $trimmoLog{$id[1]} = "trimmo_summary";
		}
	    }
	}
    }
    for $key (sort keys %trimmoLog){
	print LOG "$key\n";
    }
##Correct and (de novo) assemble reads using BayesHammer from Spades package:
    system("/usr/bin/SPAdes-3.11.1-Linux/bin/spades.py -k 77 --careful -1 ${x2}_1_out.fastq -2 ${x2}_2_out.fastq -o Corrected_Reads/${x2}");

##Rename and relocate corrected read libraries:
    system("mv Corrected_Reads/${x2}/corrected/${x2}_1_out.00.0_0.cor.fastq.gz  ${x2}_1_corrected.fastq.gz");
    system("mv Corrected_Reads/${x2}/corrected/${x2}_2_out.00.0_0.cor.fastq.gz  ${x2}_2_corrected.fastq.gz");
    system("gunzip ${x2}_*_corrected.fastq.gz");

##Delete raw fatsq.gz files
    system("rm ${x2}_*.fastq.gz");

##Run Fastqc on all processed libraries
    system("fastqc ${x2}_1_corrected.fastq");
    system("fastqc ${x2}_2_corrected.fastq");

##Compress or remove irrelevant files:
#    system("gzip *.fastq");
    system("unzip  ${x2}_1_corrected_fastqc.zip");
    system("unzip ${x2}_2_corrected_fastqc.zip");
    system("rm -rf ${x2}_*_corrected_fastqc/I* ${x2}_*_corrected_fastqc/*html ${x2}_*_corrected_fastqc/summ* ${x2}_*_corrected_fastqc/*zip");


##Examine Fastqc output files:
    open (QC, ">>./QC_summary_stats.txt");
#Quality check of forward PE library## 
    open IN2,"${x2}_1_corrected_fastqc/fastqc_data.txt" or die "Can't read\n";
#    print QC "LIBRARY: ${x2}_1\n";
    &check_qc;
#Quality check of reverse PE library## 
    open IN2,"${x2}_2_corrected_fastqc/fastqc_data.txt" or die "Can't read\n";
#   print QC "LIBRARY: ${x2}_2\n";                                                                                                                                                
    &check_qc;

    sub check_qc {
	my @qcresult= <IN2>;
	chomp(@qcresult);
	$joined_lines = join("\n", @qcresult);
#	print "$joined_lines\n";
	@module = split/>>END_MODULE/,$joined_lines;
	chomp(@module);
	$number_mod = scalar(@module);
#	print "$number_mod\n"; #11 modules
	
	for $e (0..$#module){}
#####Basic Statistics##
	$QC{basic_stats} = "$module[0]";
	print QC "$QC{basic_stats}\n\n";

#####Basic Statistics: Check overall GC content##
	@basicStat = split/\n/,$module[0];
	for $bS (0..$#basicStat){}
#	print "$basicStat[3]\n";
	@library = split/\s+/,$basicStat[3];
	for $l (0..$#library){}
#	print "$library[1]\n";
	$library[1] =~ s/_out.fastq/ /g;
	@gc = split/\s+/,$basicStat[9];
	for $c (0..$#gc){}
#	print "$gc[1]\n";
	if ($gc[1] >= 50){
	    print QC "The overall GC content of $library[1] is $gc[1] => Good library\n";
	}
	else {
	    print QC "The overall GC content of $library[1] is below 50 => Bad library\n";
	}
#####Per base sequence quality## 
	$QC{base_qual} = "$module[1]";
#	print QC "$QC{base_qual}\n\n";
	
#####Per sequence quality scores##
	$QC{seq_qual} = "$module[2]";
#	print "$QC{seq_qual}\n";
	
#####Per base sequence content##
#	$QC{seq_content} = "$module[3]";
#	print "$QC{seq_content}\n";
	@seqGC = split/\n+/,$module[5];
	for $s (@seqGC){
	    if ($s =~ /[0-9]/){
		@perseqGC = split/\s+/,$s;
		for $ps (0..$#perseqGC){
		    if ($perseqGC[0] >= 40 && $perseqGC[0] <= 75){
#			print "$perseqGC[0]\t$perseqGC[1]\n";
			@goodGC = split/\s+/,$perseqGC[1];
			for $g (@goodGC){
			    map { $sum += $g } @goodGC;
			}
		    }
		    else {
#			print "$perseqGC[0]\t$perseqGC[1]\n";
			@badGC = split/\s+/,$perseqGC[1];
			for $b (@badGC){
			    map { $sum1 += $b } @badGC;
			}
		    }
		}
	    }
	}
#	print "Total number of sequences with 40% to 75% GC content in $library[1]: $sum\n";
#	print "Total number of sequences with less than 45% and greater than 75% GC content in $library[1]: $sum1\n";
	
#####Per base GC content##
	$QC{baseGC} = "$module[4]";
#	print "$QC{baseGC}\n";
	
#####Per sequence GC content##
	$QC{seqGC} = "$module[5]";
#	print "$QC{seqGC}\n";
	
#####Per base N content##
	$QC{baseN} = "$module[6]";
#	print "$QC{baseN}\n";
	
#####Sequence Length Distribution##
    $QC{length} = "$module[7]";
#	print "$QC{length}\n";
	
#####Sequence Duplication Levels##
    $QC{seqDup} = "$module[8]";
#	print "$QC{seqDup}\n";
    }
}

system("chmod 744 */*");
system("multiqc *_corrected_fastqc .");
system("rm -rf *_corrected_fastqc");


close $fh; #close trimmo log files
close(IN); #close fastq file list
close (IN2); #close fastqc_data files

exit;
