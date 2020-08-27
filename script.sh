
gisaid_alignment=/home/bacterio/Copy/16.covid_cirad/GISAID/00.raw_data/msa_0613/msa_0613.fasta
echo $gisaid_alignment
gisaid_alignment_no_extension=$(echo $gisaid_alignment | sed s/.fasta$//)
echo $gisaid_alignment_no_extension

# Step 1. Delete line breaks inside each fasta sequence to make further steps easier
perl -ne 'if(/^>/ ){ $a++; if($a == 1){ print $_ }else{ print "\n" . $_ } }else{ s/\r?\n//g;print };' $gisaid_alignment > ${gisaid_alignment_no_extension}_inline.fasta

# verification that no sequence contains "X" because i will use this character to illustrate positions to delete
grep -v '>' ${gisaid_alignment_no_extension}_inline.fasta | grep 'X'

# reference sequence MUST be the first one of the file, in order for the step 2 script to work.
grep -A1 'EPI_ISL_402125'  ${gisaid_alignment_no_extension}_inline.fasta > ${gisaid_alignment_no_extension}_inline_ref.fasta
cat ${gisaid_alignment_no_extension}_inline.fasta >> ${gisaid_alignment_no_extension}_inline_ref.fasta

# Step 2. Identify gaps in the genome chosen as the reference and delete them for every sequence of the dataset
perl -ne 'if(/^>/ ){ print; }else{ if($. == 2){

$offset = 0;
$result = index($_, "-", $offset);

$h{$result} = 1;

while ($result != -1) {
$Nperl_numbering{$result}++; 
$offset = $result + 1;
$result = index($_, "-", $offset);
if($result != -1){
$h{$result} = 1;
}
}
$sequence = $_;
foreach $k ( keys %h){substr( $sequence, $k, 1 ) =~ s/./X/ }; 
$sequence =~ s/X//g;
print $sequence ;

}else{

$sequence = $_;
foreach $k ( keys %h){substr( $sequence, $k, 1 ) =~ s/./X/ }; 
$sequence =~ s/X//g;
print $sequence ;

}};'  ${gisaid_alignment_no_extension}_inline_ref.fasta > ${gisaid_alignment_no_extension}_inline_no_gap.aln

echo '
################# 
Output file is ${gisaid_alignment_no_extension}_inline_no_gap.aln
#################
'

# Further steps are not mandatory

############################################################################
############## rename sequences with EPI_ISL identifier only ###############
############################################################################
# Modify fasta sequence names to keep only the epi_isl identifier
perl -F'\|' -ane 'if(/^>/){print ">" . $F[1] . "\n"}else{print}'  ${gisaid_alignment_no_extension}_inline_no_gap.aln > ${gisaid_alignment_no_extension}_inline_no_gap_epi.fasta

############################################################################
############## only keep certain sequences from alignement #################
############################################################################
# This script (available at https://github.com/DamienFr/Extract_specific_sequence_from_fasta_or_fastq) extracts given sequences out of a fasta file.
# Extracted sequences must be provided in a csv file 
perl Extract_specific_sequences_from_fastq_or_fasta.pl -c id_to_keep -i ${gisaid_alignment_no_extension}_inline_no_gap_epi.fasta -o ${gisaid_alignment_no_extension}_inline_no_gap_epi_downsampled.aln

