#!//usr/bin/perl -w
use strict;
use Getopt::Std;

sub getIndexes(@);
sub overlap($$$$);
sub collapse(@);
sub getCollapsedInfo($$);
sub process($$);

my $UsageInfo = 
        "***Description***\n".
        "\tGiven an file with at least 3 whitespace separated columns (ID start and end)".
        "\t\tCollapsed together rows with the same id and overlap by a given percentage\n".
        "***Usage***\n".
        "\tperl collapseOverlap.pl [-options] AMRStruct ...\n". 
        "***ARGUMENTS***\n".
        "\tAMRStruct\tA file with at least 3 whitespace separated columns (ID start end)\n".
        "\t\t and any additional info columns\n".
        "***OPTIONS***\n".
        "\t-t [0-1]\tThreshold amount of overlap [Default: 0.5]\n".
        "\t-f char \tInfo field delimiter [Default '_']\n".
        "\t-g char \tSeparator for concatenated info columns [Default ';'] (Use with -c)\n". 
        "\t-c\t\tConcatenate different info columns when collapsing\n".
        "\t-m\t\tMemory Efficient Mode (Assumes input is sorted by ID column)\n".
        "\t-s\t\tDo not strip version numbers\n".
        "\t-h\t\tDisplay this message and exit\n".
        "***Example***\n".
        "\tUsing memsave mode\n".
        "\tFOR AMR STRUCT: collapseOverlap.pl -s -m -c -t 0.99 AMRstruct".
        "\tFOR AMR BLAST: sort AMRblaststruct | collapseOverlap.pl -s -m -f ' ' -t 0.99 /dev/stdin\n";

my %opts;
getopts('t:f:g:csmh',\%opts);

if(@ARGV < 1 || exists($opts{'h'})){
    die $UsageInfo;
}

my $t = exists($opts{'t'}) ? $opts{'t'} : 0.5;
die "-t must be between 0 and 1 (inclusive)\n" unless($t >=0 and $t <= 1);
my $ConcatSep = exists($opts{'g'}) ? $opts{'g'} : ';';
my $InfoSep = exists($opts{f}) ? $opts{f} : '_';
my $bStrip = exists($opts{'s'}) ? 0 : 1;
my $bConcat = exists($opts{'c'}) ? 1 : 0;
my $bMemSave = exists($opts{m}) ? 1 : 0;

my $AMRStruct = shift(@ARGV);

my %Entries; #Hash of array of hashes ACC->[1:{start,end,fileno}, 2:{start,end,fileno}, ...]
my @EntryRows; #Array of hashes (Component of Above)

open(my $fh,$AMRStruct) or die "Could not open $AMRStruct\n$!\n";
my $lastacc;
while(<$fh>){
    chomp;
    my($_acc,$s,$e,@f) = split(/\s+/);
    my $acc = $_acc;
    if($bStrip){
        my @tmp = split(/\./,$acc);
        $acc = $tmp[0] if @tmp;
    }
    my $f = join($InfoSep,@f);
    if($bMemSave){
        unless(!defined($lastacc) or $acc eq $lastacc){
            process($lastacc,\@EntryRows); 
            @EntryRows = ();
        }
        $lastacc = $acc;
        push(@EntryRows,{start => $s, end => $e, fileno => $f});
    } else {
        if(exists($Entries{$acc})){
            push(@{$Entries{$acc}},{'start' => $s, 'end' => $e, 'fileno' => $f});
        } else {
            $Entries{$acc} = [{'start' => $s, 'end' => $e, 'fileno' => $f}]; 
        }
    }
}
close($fh);

my $debug = 0;

#MAIN
if($bMemSave){
    process($lastacc,\@EntryRows);
} else {
    process($_,$Entries{$_}) foreach (sort(keys(%Entries)));
}

sub getIndexes(@){ 
    my @hashlist = @_;
    my @startlist;
    my @endlist;
    my @flist;
    foreach my $hashref (@hashlist){
        push(@startlist,$hashref->{'start'});
        push(@endlist,$hashref->{'end'});
        push(@flist,$hashref->{'fileno'});
    }
    return (\@startlist,\@endlist,\@flist);
}

sub overlap($$$$){
    my ($s1,$e1,$s2,$e2) = @_;
    return -1 if($e1 < $s1 or $e2 < $s2);
    my $overlap = 0;
    if($e1 >= $s2 and $s1 <= $e2){
        $overlap = $e1 - $s2 + 1 - (($s1 > $s2) ? ($s1 - $s2) : 0) - (($e1 > $e2) ? ($e1 - $e2) : 0);
    }
    return $overlap;
}

sub collapse(@){
    my @startlist = @{shift(@_)};
    my @endlist = @{shift(@_)};
    my $bCollapse;
    my $nNoCollapse = 0;
    my @indexlist = (0 .. $#startlist);
    do{
        $bCollapse = 0;
        my $s1 = shift(@startlist);
        my $e1 = shift(@endlist);
        my $ind = shift(@indexlist);
        ($e1,$s1) = ($s1,$e1) if($e1 < $s1);
        my $l1 = $e1 - $s1 + 1;
        for(my $i = 0; $i < @startlist and !$bCollapse; $i++){
            my ($s2,$e2) = ($startlist[$i],$endlist[$i]); 
            if($e2 < $s2){
                ($e2,$s2) = ($s2,$e2);
                $startlist[$i] = $s2;
                $endlist[$i] = $e2;
            }
            my $o = overlap($s1,$e1,$s2,$e2);
            if($o == -1){
                die "ERROR: Invalid start($s1 or $s2) and end($e1 or $e2)\n";
            }
            if($o){
                my $l2 = $e2 - $s2 + 1;
                my $p = $o / (($l1 <= $l2) ? $l1 : $l2);
                if($p > $t){
                    $endlist[$i] = ($e2 > $e1) ? $e2 : $e1; 
                    $startlist[$i] = ($s2 < $s1) ? $s2 : $s1;
                    $indexlist[$i] .= ";;;$ind";
                    $bCollapse = 1;
                }
            }
        }
        if($bCollapse){
            $nNoCollapse = 0;
        } else{
            push(@startlist,$s1);
            push(@endlist,$e1);
            push(@indexlist,$ind);
            $nNoCollapse++;
        }
    } while($nNoCollapse < @startlist -1);
    return (\@startlist,\@endlist,\@indexlist);
}


sub getCollapsedInfo($$){
    my ($iref,$flistref) = @_;
    my @fList;
    for(my $i = 0; $i < @{$iref}; $i++){
        my %fDict;
        my @ilist = split(';;;',$iref->[$i]);
        foreach my $ind (@ilist){
            if(defined($flistref->[$ind])){
                if(exists($fDict{$flistref->[$ind]})){
                    $fDict{$flistref->[$ind]} += 1;
                } else {
                    $fDict{$flistref->[$ind]} = 1;
                }
            }
        }
        my $f;
        if($bConcat){
            $f = join($ConcatSep,keys(%fDict));
        } else {
            my $max = -1;
            foreach my $key (keys(%fDict)){
                if($fDict{$key} > $max){
                    $max = $fDict{$key};
                    $f = $key;
                }
            }    
        }
        $f = "" unless(defined($f));
        push(@fList,$f);
    }
    return(\@fList);
}


sub process($$){
    my ($acc,$EntryRef) = @_;
    my ($slistref,$elistref,$flistref) = getIndexes(@{$EntryRef});
    my ($sref,$eref,$iref) = collapse($slistref,$elistref);
    my $fref = getCollapsedInfo($iref,$flistref);
    for(my $i = 0; $i < @{$sref}; $i++){
        print "$acc $sref->[$i] $eref->[$i] $fref->[$i]\n";
    }

}
