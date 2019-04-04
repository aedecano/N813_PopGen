#!/usr/bin/perl
use strict;
# Need spe-name for the afl and indel files
#ASCII translation table
#my %ASCII=qw(#    );
#weight for BQ count.
my %BaseWeight=qw(
25 1.00000000
24 0.79432823
23 0.63095734
22 0.50118723
21 0.39810717
20 0.31622777
19 0.25118864
18 0.19952623
17 0.15848932
16 0.12589254
15 0.10000000
14 0.07943282
13 0.06309573
12 0.05011872
11 0.03981072
10 0.03162278
9 0.02511886
8 0.01995262
7 0.01584893
6 0.01258925
5 0.01000000
4 0.00794328
3 0.00630957
2 0.00501187
1 0.00398107
0 0.00000000);

my ($in, $SPID )=@ARGV;
if (!$SPID)
{
die "put strain name\n";
}
my (@x,@base,@bq,%Bfreq,%TotalBQ,$TotalBase);
# conut the numbe of bases and check their base quality
#
#
# strand
my %same=qw(. . , .  A A a A c C C C t T T T g G G G N N - -);
my @PrintL=("A 1","a 1", "A 0","a 0", "SPA", "C 1","c 1", "C 0","c 0", "SPA" ,"G 1","g 1","G 0","g 0","SPA" , "T 1","t 1", "T 0","t 0","SPA","N 0","- 0");
my @AM=("A 1","a 1", "A 0","a 0");
my @CM=("C 1","c 1", "C 0","c 0");
my @GM=("G 1","g 1","G 0","g 0");
my @TM=("T 1","t 1", "T 0","t 0");
my (@av,@cv,@gv,@tv);
my %refB;
my $CUTbq=25;
my $SHIFT=33;
my ($CUT25,$CUT20,$CUT15,$CUT10,$CUT5,$CUT0)=qw(1 0.5 0.25 0.1 0.05 0.01);
my (%refBase,$aveBQ,%Bfreq25,$CUTbqv,$mybase);
my @A1=qw(A C G T);
my @A2=qw(a c g t);my $dullsum="";
if ($in!~"gz"){
    open F1, $in or die("need maq pile up.");
}
else{
    open F1, ("gzip -dc $in |") or die("need maq pile up.");
}
open INDEL,">$SPID.bam.indel" or die("INDEL.");
my %Count=qw(A 0 C 0 G 0 T 0 N 0 "-" 0);
my $baseP=8;
my $bqP=9;
my $baseB;
my %record;
my $printline;my $printline2;my ($bf4,@BfreqEnt,$ent1);
while (my $s=<F1>)
{
  (@x)=split '\s+',$s;
  #NODE_10020_length_4499_cov_37.070236 835     T       C       53      81      58      19      CCCCCCCcccccCcccCc,     ?;?==?>><?>:@A=;>,@
  #     CCCCCCCcccccCcccCc,
  #       ?;?==?>><?>:@A=;>,@
  #
  # 0         1     2   3   4   5   6    7     8
  #Chrom1   12005   C   S  20  20   29   60    ,$,$,.,.,.,..,.,..,,,,.,...,,......,...,,,GGGGg,,.,..GGGGGgg,.  @?>5?<@-<711->/9=9@>4??>7???>?==>?=?>>94>:>>10
>?1=>?>??=9*86
  #,$,$,.,.,.,..,.,..,,,,.,...,,......,...,,,GGGGg,,.,..GGGGGgg,.
  #@?>5?<@-<711->/9=9@>4??>7???>?==>?=?>>94>:>>10>?1=>?>??=9*86
  #NODE_10601_length_36487_cov_34.105545   33975   T       Y       63      63      32      68      ....,...,,,,,.,,,,....,,,.,.,,,....,,,CCCCCccCCC.CCcCcccc.
.,,.,,C..^~.  >>98?=>=>=A>?=?>??>3>6>>??>?=:>???>?<>3>??>::1>??><,>*5,-=@5.>:,?@??
  #....,...,,,,,.,,,,....,,,.,.,,,....,,,CCCCCccCCC.CCcCcccc..,,.,,C..^~.
  #>>98?=>=>=A>?=?>??>3>6>>??>?=:>???>?<>3>??>::1>??><,>*5,-=@5.>:,?@??
  $baseB=$x[$baseP];
  #print "\n1)$baseB\n";
  #remove all the non bases.
  $baseB=~s/\^.|\$|\-|\+|\d//g;
  #there is no more junk.
  #print "\n2)$baseB\n";
  #@base=split "",$x[$baseP];
  @base=split "",$baseB;
  @bq=split "",$x[$bqP];
  if ( $x[2] eq "\*")
  {
     print INDEL "$SPID $s";
      next;
  }
  #chck the strand
  %refB=("\,",lc($x[2]),"\.",$x[2]);#"c","c","T","T","A","A","G","G","N","N","-","-");
  #$take both L,C.
  my (@basel,$b0,$bq01);
  #checking base along the pileup
  ###print  @base,"H\n";
  for my $i (0..$#bq)

  # for my $i (1..$#bq)
  {
    if ($base[$i] eq "\."){
      $mybase=$x[2];
    }elsif($base[$i] eq "\,"){
      $mybase=lc($x[2]);
    }elsif ($base[$i]=~/[ATCGNatcgn]/){
      $mybase=$base[$i];
    }elsif ($base[$i] eq "\*")
    {
      $mybase="-";
    }else{
      die( " ($base[$i]),$i wrong base >>> ($mybase) $s $#bq\n");
    }

    #print "$i $mybase\n";
    ++$Bfreq{$mybase};
    #$CUTbqv=($ASCII{$bq[$i]}- $SHIFT);
    $CUTbqv=ord($bq[$i])- $SHIFT;
    #print ">>$CUTbqv\n";
    ###### biger than 25
    if ( $CUTbqv>= $CUTbq)
    {
    $CUTbqv=1;
  } else
  {
    $CUTbqv=0;
  }
####h1
  #++$Bfreq{$same{$base[$i]}};
  ++$Bfreq25{"$mybase $CUTbqv"};
  #$TotalBQ{"$mybase $CUTbqv"}+=$ASCII{$bq[$i]}- $SHIFT;
  $TotalBQ{"$mybase $CUTbqv"}+=ord($bq[$i])- $SHIFT;
  #print $ASCII{$bq[$i]}-32, " $base[$i]";
      #print  "CH:$same{$mybase} $CUTbqv\n";
}
#print out
print "$SPID $x[0] $x[1] $x[2] $x[3] $x[4] $x[5] $x[6] $x[7]  ";
#@PrintL=("A 1","C 1","G 1","T 1","N 0","- 0", "A 0","C 0","G 0","T 0");


#h1
$printline="";
for my $i (@PrintL)#printing the base frequency with ave bq
{
  if ($i eq "SPA"){
  $printline.="|";
  next;
  }
  $aveBQ=sprintf"%0.0f",divi($TotalBQ{$i},$Bfreq25{$i});
  ($b0,$bq01)=split  '\s+',$i;
     #print "($refB{$b0} $b0 $bq01;$i; $Bfreq25{$i}: $aveBQ )|";
  if ($Bfreq25{$i})
  { # A C G T
    $printline.=" $Bfreq25{$i} $aveBQ ";
    BaseCount($Bfreq25{$i},$i,$aveBQ,\%Count,\$TotalBase); ####This will define %Count
    } else #not defined
    {
      #print " 0 $aveBQ ";
      $printline.=" 0 $aveBQ ";
    }
  }
$printline2="";
 #printing bases
for   (0..3){  # F and R  (A C G T)
    $bf4= sprintf " %0.4f", divi($Count{$A1[$_]},$TotalBase) + divi($Count{$A2[$_]},$TotalBase);
    $printline2.= $bf4;;
    push @BfreqEnt,$bf4;
}

for (0..$#AM){
  $av[0]+=$Bfreq25{$AM[$_]};
  $cv[0]+=$Bfreq25{$CM[$_]};
  $gv[0]+=$Bfreq25{$GM[$_]};
  $tv[0]+=$Bfreq25{$TM[$_]};
}
#forward
for (0,2){
  $av[1]+=$Bfreq25{$AM[$_]};
  $cv[1]+=$Bfreq25{$CM[$_]};
  $gv[1]+=$Bfreq25{$GM[$_]};
  $tv[1]+=$Bfreq25{$TM[$_]};
}
#reverse
for (1,3){
  $av[2]+=$Bfreq25{$AM[$_]};
  $cv[2]+=$Bfreq25{$CM[$_]};
  $gv[2]+=$Bfreq25{$GM[$_]};
  $tv[2]+=$Bfreq25{$TM[$_]};
}

for (0..2){
 $dullsum.="| $av[$_] $cv[$_] $gv[$_] $tv[$_] ";
}

$ent1= sprintf "%0.5f", entropySUM(@BfreqEnt);
@BfreqEnt="";
  print "$printline2 | $ent1 $printline |$dullsum\n";
%Bfreq=""; %Bfreq25="";$TotalBase=0;$dullsum="";
%TotalBQ=""; %Count="";  (@av, @cv, @gv, @tv)="";   #  %Count=qw(A 0 C 0 G 0 T 0 N 0 "-" 0);
}



# for my $i (keys %record)
#{
#print "GGGGGGGGGGGGGGGGGGGGG $i $record{$i}\n";
#
#}


# take a hash and ave, then return a count hash.
#$Bfreq25{$i} $aveBQ %Count
# BaseCount($Bfreq25{$i},$i,$ave,%Count,$TOTAL);
sub BaseCount {
  my ($Bfreq25,$i,$ave,$rCount,$TOTAL) = @_;
  my ($A)=split '\s+', $i;

  if ( $ave>=25 ){
    $$rCount{$A}+=$Bfreq25*$CUT25;
    $$TOTAL+=$Bfreq25*$CUT25;
  }elsif ( $ave>=20 ){
    $$rCount{$A}+=$Bfreq25*$CUT20;
    $$TOTAL+=$Bfreq25*$CUT20;
  }elsif( $ave>=15 ){
    $$rCount{$A}+=$Bfreq25*$CUT15;
    $$TOTAL+=$Bfreq25*$CUT15;
  }elsif( $ave>=10 ){
    $$rCount{$A}+=$Bfreq25*$CUT10;
    $$TOTAL+=$Bfreq25*$CUT10;
  }elsif( $ave>=5 ){
    $$rCount{$A}+=$Bfreq25*$CUT5;
    $$TOTAL+=$Bfreq25*$CUT5;
  }else{
    $$rCount{$A}+=$Bfreq25*$CUT0;
    $$TOTAL+=$Bfreq25*$CUT0;
  }
}
sub BaseCount2 {
  my ($Bfreq25,$i,$ave,$rCount,$TOTAL) = @_;
  my ($A)=split '\s+', $i;
  if ( $ave>=25 ){
    $$rCount{$A}+=$Bfreq25*$BaseWeight{25};
    $$TOTAL+=$Bfreq25*$BaseWeight{25};
  }else
  {
    $$rCount{$A}+=$Bfreq25*$BaseWeight{int($ave)};
    $$TOTAL+=$Bfreq25*$BaseWeight{int($ave)};
  }
}
sub divi {
  my ($num,$deno)=@_;
  if ($deno==0)
  {                             # print ">>> $num,$deno,\n";
    return "0";
  } else
  {
    #print ">>> $num  $deno       \n";
    return $num*1.0/$deno;
  }
}

sub add_vecpair {       # assumes both vectors the same length
    my ($x, $y) = @_;   # copy in the array references
    my @result;
  for (my $i=0; $i < @$x; $i++) {
      $result[$i] = $x->[$i] + $y->[$i];
    }
    return @result;
}

 sub hashcheck {
   my ($x) = @_;
  my $h;
   if ($x)
   {$h=$x;}
   else
   {$h="x";}
   return $h;
 }

sub AFLdistance {
  my ($x1, $x2,$x3,$x4,$y1,$y2,$y3,$y4) =@_;
  #print  "($x1, $x2,$x3,$x4,$y1,$y2,$y3,$y4)\n";
  return ($x1-$y1)*($x1-$y1)+($x2-$y2)*($x2-$y2)+($x3-$y3)*($x3-$y3)+($x4-$y4)*($x4-$y4);
}

sub rnd {
    my($number) = shift;
    return int($number + .5 * ($number <=> 0));
}
 #entropy($Count{$k},$TotalBase);

sub entropy {
  my ($freq,$sum)=@_;
  my $p= divi($freq,$sum);
  return sprintf "%0.8f",$p*logbase($p,2);
}
sub entropySUM {
 #take array
  my (@Fre)=@_;
  my $entropy=0;
  my $sum=sumAR(@Fre) ;
  my $p=0;
  for my $freq (@Fre){
    $p=divi($freq,$sum);
    $entropy+=$p*logbase($p,2);
   }
  return sprintf "%0.8f",-$entropy;
}
sub sumAR {
 my (@Fre)=@_;
 my $sum=0;
  for my $i (@Fre)
  {  $sum+=$i;     }
  return $sum;
}

sub logbase {
  my ($number,$base)=@_;
  return if $number <=0 or $base <= 0 or $base ==1;
  return log($number)/log($base);
}

exit;
