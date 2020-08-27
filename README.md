# Gapped_SARS-CoV-2_Gisaid_alignment_to_ungapped_alignment

# DESCRIPTION

	This is a quick-and-dirty way of transforming a gapped alignment into a ungapped alignment.
	It has been developed in order to obtain a SARS-CoV-2 alignement matching the size of the usualy
	used reference genome (Wuhan-Hu-1) from a gapped alignment downloaded from Gisaid's website.
	The idea is basically to choose a reference among the aligned sequences (Wuhan-Hu-1 in our case)
	and to delete from all sequences the positions corresponding to "-" in that reference. 

Input
>>Wuhan-Hu-1  
ATGCGTGAGTCGA---TAGTGCTGATGCTGAT  
>Sequence_2  
ATGCGTGAGTCGATCGTAGTGC---TGCTGAT  

Output
>Wuhan-Hu-1
ATGCGTGAGTCGATAGTGCTGATGCTGAT
>Sequence_2
ATGCGTGAGTCGATAGTGC---TGCTGAT

# USAGE

	Change $gisaid_alignment variable to match the location of your downloaded Gisaid alignment
	and copy / paste the rest of the code into a unix terminal.

# AUTHOR

	Damien Richard, 2020
