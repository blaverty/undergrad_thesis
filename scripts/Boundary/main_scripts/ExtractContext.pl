#!/usr/bin/perl -w
use strict;

use Getopt::Std;
use Scalar::Util qw(looks_like_number);
use Parallel::ForkManager;
#use Sys::Info;
#use Sys::Info::Constants qw( :device_cpu );

my $UsageInfo = "ExtractContext.pl [-options] FastaDir AMRStruct\n";
sub ProcessStruct($);
sub printfw($$$);

my %opts;
getopts('hemfsc:i:x:p:',\%opts);

if(exists($opts{'h'})){
    die "***Usage***\n".
        $UsageInfo.
        "***Arguments***\n".
        "Fastadir	A directory containing fasta formatted files to extract context from\n".
        "AMRStruct	A Space separated file with an file identifier, start, end, and optional extra info on each line\n".
        "***Options***\n".
        "-e	Allow internal info to extend outside the opposite end of the target sequence\n".
        "-m	Merge contexts which overlap internally from being merged\n".
        "-f 	Append fasta header info to extracted context headers\n".
        "	Note: Ignores accession number in header\n".
        "-s	Strip Version Numbers\n".
        "-c int	The amount of context to extract [Default 300 bp]\n".
        "-i int	The amount of internal info to extract [Default 75bp]\n".
        "-x str	The file extension for files in the FastaDir [Default '']\n".
        "-p int The number of cores to run with (0 is max) [Default 8]\n".
        "***Notes***\n".
        "If gene indexes are provided end-start instead of start-end it is assumed\n".
        "\tthat the gene is on the opposite strand, this swaps which context oligo\n".
        "\tis considered to be up or downstream\n";
}
if(@ARGV < 2){
    die $UsageInfo."Use -h for more info\n";
}

#Process Contex Length
my $contextlength = exists($opts{'c'}) ? $opts{'c'} : 300;
unless(looks_like_number($contextlength)){
    die "TYPE ERROR: Context Length must be a number greater than 0\n";
}
if($contextlength < 0){
    warn "WARNING: Context Length must be at least 0\n\tDefaulting to 0bp\n";
    $contextlength = 0;
}
if(int($contextlength) != $contextlength){
    warn "WARNING: Context Length must be an integer\n\tTruncating\n";
    $contextlength = int($contextlength);
}
#Process Internal Length
my $internlength = exists($opts{'i'}) ? $opts{'i'} : 75;
unless(looks_like_number($internlength)){
    die "TYPE ERROR: Internal Length must be a number greater than 0\n";
}
if($internlength < 0){
    warn "WARNING: Internal Length must be at least 0\n\tDefaulting to 0bp\n";
    $internlength = 0;
}
if(int($internlength) != $internlength){
    warn "WARNING: Internal Length must be an integer\n\tTruncating\n";
    $internlength = int($internlength);
}
#Process Cores
my $cores = exists($opts{'p'}) ? $opts{'p'} : 8;
unless(looks_like_number($cores)){
    die "TYPE ERROR: Number of cores must be a number, and at least 0\n";
}
if(int($cores) != $cores){
    warn "WARNING: Number of cores must be an integer\n\tTruncating\n";
    $cores = int($cores);
}

if($cores < 0){
    die "VALUE ERROR: Number of cores must be at least 0\n";
}
chomp(my $max_cores = `grep -c -P '^processor\\s+:' /proc/cpuinfo`);
if($cores == 0 or $cores > $max_cores){
    if($cores > $max_cores){
        warn "WARNING: Number of requested cores higher than maximum\n\tDefaulting to $max_cores\n";
    }
    $cores = $max_cores;
}

#Process Other Options
my $bExtend = exists($opts{'e'}) ? 1 : 0;
my $bMerge = exists($opts{'m'}) ? 1 : 0;
my $bAppHeader = exists($opts{'f'}) ? 1 : 0;
my $bStrip = exists($opts{'s'}) ? 1 : 0;
my $extension = exists($opts{'x'}) ? $opts{'x'} : "";
if($extension =~ s/^\.//){
    warn "WARNING: File extensions do not require a leading '.'\n"
}

my ($FastaDir,$AMRStruct) = @ARGV;
unless(-d $FastaDir){
    die "DIR ERROR: Directory $FastaDir does not exists\n";
}
unless(-e $AMRStruct){
    die "FILE ERROR: File $AMRStruct does not exist\n";
}

#Load Structure
my @StructList;
opendir(my $dh, $FastaDir) or die "Cant open $FastaDir: $!\n";
my @DirContents = readdir($dh);
closedir($dh);
open(my $fh, $AMRStruct) or die "Could not open $AMRStruct\n";
while(<$fh>){
    chomp;
    push(@StructList,$_);
}
close($fh);
#Process Structures in Parallel
my $pm = Parallel::ForkManager->new($cores);
my %results;
$pm->run_on_finish( sub{
        my($pod,$exit_code,$ident,$exit_signal,$core_dump,$data_structure_ref) = @_;
        my $q = $data_structure_ref->{'input'};
        $results{$q} = $data_structure_ref->{'result'};
});
foreach my $struct (@StructList){
    my $pid = $pm->start and next;
    my $res = ProcessStruct($struct);
    $pm->finish(0, {result => $res, input => $struct});
}
$pm->wait_all_children;
#Output Results
for my $struct (@StructList){
    if(exists($results{$struct}) and defined($results{$struct})){
        print $results{$struct};
    }
}

sub ProcessStruct($){ 
    my $returnVal;
    my $line = shift;
    my($_acc,$s,$e,@info) = split(/ /,$line);
    my $acc = $_acc;
    if($bStrip){
        my @tmp = split(/\./,$acc);
        $acc = $tmp[0] if(@tmp);
        my @files = grep (/^$acc/, @DirContents);
        $acc = $files[0] if (@files);
    }
    my $info = "";
    $info = join('|',@info) if(@info);
    my $seq = "";
    my $file = $FastaDir."/".$acc;
    $file .= ".$extension" if($extension ne "" and !$bStrip);
    if(-e $file){
        open(my $fh2, $file) or die "Could not open $file\n\$!\n";
        my $header = <$fh2>;
        chomp($header);
        $header =~ s/^>$acc\s*//;
        $info .= "|$header" if($bAppHeader); 
        while(my $line = <$fh2>){
            chomp($line);
            $seq .= $line;
        }
        close($fh2);
    }
    if($seq ne ""){
        my @streamList = ("up","down");
        if($s < 1){
            warn "WARNING: Invalid Start index of $s for $_acc\n".
            "Gene Start is before Sequence Start\nReturning Empty context\n";
            return undef;
        }
        if($e > length($seq)){
            warn "WARNING: Invalid End index of $e for $_acc\n".
            "Gene End is after Sequence End\nReturning Empty context\n";
            return undef;
        }
        if($s > $e){
            ($s,$e) = ($e,$s);
            @streamList = ("down","up");
        }
        my @ci = ($s - $contextlength,$s + $internlength-1,$e-$internlength+1, $e + $contextlength);
        for (my $i = 0; $i < 4; $i++){ #Ensure Contexts don't extend outside of fasta file
            $ci[$i] = ($ci[$i] < 1) ? 1 : $ci[$i];
            $ci[$i] = ($ci[$i] > length($seq)) ? length($seq) : $ci[$i];
        }
        unless($bExtend){ #Prevent internal region from extending outside of the gene
            $ci[1] = ($ci[1] > $e) ? $e : $ci[1];
            $ci[2] = ($ci[2] < $s) ? $s : $ci[2];
        }
        if($bMerge and $ci[1] >= $ci[2]){ #Merge contexts which overlap internally
            @ci = @ci[(0,3)];
        }
        for(my $i = 0; $i < @ci; $i+=2){
            my $stream = $streamList[$i/2];
            $returnVal .= ">gb|$acc|$ci[$i]-$ci[$i+1]|${stream}stream|$info\n";
            my $offset = $ci[$i+1] - $ci[$i] + 1; 
            $returnVal .= printfw(substr($seq,$ci[$i]-1,$offset),0,60);
        }
    } else {
        warn "WARNING: No sequnce found for $acc\n";
    }
    return $returnVal
}

sub printfw($$$){
    my($str,$curWidth,$Width) = @_;
    if($curWidth >= $Width){
        print "\n";
        $curWidth = 0;
    }
    my $i = 0;
    my $prefix;
    my $output;
    my $l = length($str);
    while($str and $i < $l){
        $prefix = substr($str,0,$Width - $curWidth,"");
        my $len = length($prefix);
        $i += $len;
        $output .= "$prefix\n";
        $curWidth = ($curWidth + $len) % $Width;
    }
    return $output;
}


##### VERSION 1 - No Parallelization #####

#open(my $fh, $AMRStruct) or die "Could not open $AMRStruct\n";
#my $lastacc = "";
#my $seq = "";
#while(<$fh>){
#    chomp;
#    my($acc,$s,$e,@info) = split(/\s/);
#    my $info = "";
#    $info = join('|',@info) if(@info);
#    if($acc ne $lastacc){
#        $seq = "";
#        my $file = $FastaDir."/".$acc;
#        $file .= ".$extension" if($extension ne "");
#        if(-e $file){
#            open(my $fh2, $file) or die "Could not open $file\n\$!\n";
#            my $header = <$fh2>;
#            chomp($header);
#            $header =~ s/^>$acc\s*//;
#            $info .= "|$header" if($bAppHeader); 
#            while(my $line = <$fh2>){
#                chomp($line);
#                $seq .= $line;
#            }
#            close($fh2);
#        }
#    }
#    if($seq ne ""){
#        my @ci = ($s - $contextlength,$s + $internlength,$e-$internlength, $e + $contextlength);
#        for (my $i = 0; $i < 4; $i++){ #Ensure Contexts don't extend outside of fasta file
#            $ci[$i] = ($ci[$i] < 1) ? 1 : $ci[$i];
#            $ci[$i] = ($ci[$i] > length($seq)) ? length($seq) : $ci[$i];
#        }
#        unless($bExtend){ #Prevent internal region from extending outside of the gene
#            $ci[1] = ($ci[1] > $e) ? $e : $ci[1];
#            $ci[2] = ($ci[2] < $s) ? $s : $ci[2];
#        }
#        if($bMerge and $ci[1] >= $ci[2]){ #Merge contexts which overlap internally
#            @ci = @ci[(0,3)];
#        }
#        my $stream = "up";
#        for(my $i = 0; $i < @ci; $i+=2){
#            $stream = "down" if($i > 0);
#            print ">gb|$acc|$ci[$i]-$ci[$i+1]|${stream}stream|$info\n";
#            my $offset = $ci[$i+1] - $ci[$i] + 1; 
#            printfw(substr($seq,$ci[$i]-1,$offset),0,60);
#        }
#    } else {
#        warn "WARNING: No sequnce found for $acc\n";
#    }
#    $lastacc = $acc;
#}
#close($fh);

