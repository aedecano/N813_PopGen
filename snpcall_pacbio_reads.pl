###Script for mapping FASTQ sequences with Reference ST131 genomes using smalt and variant calling using samtools###
# module load bio
# module load fastx-toolkit/intel/0.0.14
# module load fastqc/0.10.1 
# module load bioconductor/R/intel/2.14
# module load samtools/intel/0.1.19
# module load htslib
# module load sratoolkit

system("gunzip *corrected.fastq.gz");

#::Make a hash index “hash” for the reference genome::#
#    system ("smalt index -k 19 -s 1 NCTC13441-hash /ichec/work/dclif042c/COMP_ST131/Res7_Comp_Files/NCTC13441/NCTC13441_chrom.fasta");

#::Create an index .fai file to read hash::#
#    system ("samtools faidx /ichec/work/dclif042c/COMP_ST131/Res7_Comp_Files/NCTC13441/NCTC13441_chrom.fasta");

open(IN,"in"); # open PE FASTQ file list

while(<IN>){
    chomp;
    $x = $_;
    $x =~ s/_\d\.fastq.gz//g;
    $x2 = $x;

#::Map the fastq reads (include both files) to make a SAM (samsoft)::#
    system ("smalt map -f samsoft -x NCTC13441-hash ${x2}_1_corrected.fastq ${x2}_2_corrected.fastq > ${x2}.sam"); 

#::Convert SAM to BAM with Samtools then make a table of insert sizes to get mean::#
    system ("samtools import /ichec/work/dclif042c/COMP_ST131/Res7_Comp_Files/NCTC13441/NCTC13441.fa.fai ${x2}.sam ${x2}.bam");
    system ("samtools view -f 3  ${x2}.bam  | cut -f9 > ${x2}.size.txt");

#LOAD "R"
#a = read.table("${x2}.size.txt")
#v = a[a[,1]>0,1]
###get mean insert size###
#mean(v[v>= quantile(v, seq(0,1,0.05))[2] & v<= quantile(v, seq(0,1,0.05))[20]])

#::Sort the BAM files::#
    system ("samtools sort ${x2}.bam ${x2}.bam.sorted");

#::Index the BAM files::#
    system ("samtools index ${x2}.bam.sorted.bam");

#::Remove PCR duplicate reads::#
    system ("samtools rmdup ${x2}.bam.sorted.bam ${x2}.bam.sorted.bam.rmdup");

###SNP Calling####

#::Create a BCF file::#
    system ("samtools mpileup -q 30 -Q 25 -g -u -I -d 1000 -f /ichec/work/dclif042c/COMP_ST131/Res7_Comp_Files/NCTC13441/NCTC13441_chrom.fasta ${x2}.bam.sorted.bam.rmdup | bcftools view -bvcg - > ${x2}.bcf");

#::Make VCF (variant call format) and BCF (binary VCF) files::#
    system("bcftools view ${x2}.bcf | vcfutils.pl varFilter -D500 > ${x2}.vcf");


###Zip Files###
    system("gzip *.fastq *.bcf *bam *.bam.bai *rmdup ");

#::Count the SNPs in the vcf files::#
#grep -c "gi" *vcf | more

}

