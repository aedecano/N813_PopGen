#!/usr/bin/perl
# run samtools, call SNPs
#$x = $ARGV[0]; # $x is the file name

if($ARGV[0]=~ /-Ecoli/){ $ref= "Res7-1NODEwithplasmidCTM14.fasta"; }
#print "perl $0 $ARGV[0] as perl $0 reads-reference, eg LgCL085-Lbra\nDoing $x with $ref as reference\n";

$program = "samtools";                           # v0.1.19 for mpileup
$program2 = "/usr/bin/samtools-0.1.11/samtools"; # for pileup
#system("$program import $ref.fai $x $x.bam");   # assumed to be done
#system("$program sort $x.bam $x.bam.sorted");   # assumed done
#system("$program index $x.bam.sorted.bam");     # assumed done
#system("$program rmdup $x.bam.sorted.bam $x.bam.sorted.bam.rmdup");
system("$program2 pileup -cf $ref $x > $x.pileup ");
system("/usr/bin/samtools-0.1.11/misc/samtools.pl varFilter -W 7 -N 3 -D 5000 $x.pileup > $x.pileup.temp");
system("perl Iterate.pl $x.pileup.temp $x > $x.pileup.snp");
system("gzip $x.pileup ");
system("perl HisSeqSNP1ALLIND.pl $x.pileup.snp > $x.SNP.B.pattern.3");
system("perl /home/LEISH/PERL/getstatsgenomeFAST_Chr-contigs.pl $x ");
#system("$program mpileup -q 30 -Q 25 -g -u -I -d 1000 -f $ref $x.bam.sorted.rmdup.bam | bcftools view -bvcg - > $x.bcf ");
#system("bcftools view $x.bcf | /usr/bin/samtools-0.1.11/bcftools/vcfutils.pl varFilter -D100 > $x.vcf");
#system("rm -rf $x.vcf.gz");
#system("/usr/bin/htslib/bgzip $x.vcf "); # zip file
#system("/usr/bin/htslib/tabix -p vcf $x.vcf.gz "); # tabix formatting
system("rm -rf $x.bam.indel $x.list $x.pileup.temp");
# make .snp .bcf .vcf file
exit;
