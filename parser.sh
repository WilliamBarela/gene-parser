# renice children processes
# https://www.thegeekstuff.com/2013/08/nice-renice-command-examples/?utm_source=tuicool

################################################################################
#                                                                              #
#                                                                              #
#        parser.sh genome_file repeats_file output_file num_processes          #
#                                                                              #
#                                                                              #
#                                                                              #
################################################################################

# take argvs for processors to use,key file, and serach file
# split key file into number of process files as temporty files.
# start a prcoess for each one of them.

# These steps on 36 processors should reduce the run time from 50 hours to about 2 hours
# FIXME: Need to add one liner to remove cariage returns

# get argvs
genome_file=$1
repeats_file=$2
output_file=$3
num_processes=$4

# get repeats file name without extension:
repeats_extension="${repeats_file##*.}"
clean_repeats_file="${repeats_file%.*}"_clean.fasta

# make unique list of species' repeats
cat $repeats_file | sort | uniq > $clean_repeats_file

max_lines=$(wc -l $clean_repeats_file | awk '{print $1}')
step=$(($max_lines/($num_processes))) 

seqs=($(seq 1 $step $max_lines))
seqs[$num_processes]=$max_lines
seqs_length=${#seqs[@]}

function echo_info () {
	echo "[ USER INPUT ]"
	echo -e "\tgenome file: $genome_file"
	echo -e "\trepeats file: $repeats_file"
	echo -e "\toutput file: $output_file"
	echo -e "\tnum processes: $num_processes"

	echo " "

	echo "[ DATA GENERATED ]"
	echo -e "\tclean repeats file: $clean_repeats_file"

	echo " "

	echo "[ CALCULATIONS ]"
	echo -e "\tmax lines: $max_lines"
	echo -e "\tstep size: $step"
	echo -e "\tseqs: ${seqs[@]}"
	echo -e "\tseqs_length: $seqs_length"

	echo " "

	echo "[ PAIRS ]"
	for i in $(seq 0 1 $((seqs_length - 2))); do 
		echo -e "\t[$i] [$((i + 1))] : \t${seqs[$i]}\t${seqs[$((i + 1))]}";
	done
}

# function process_child { args : integer input } {
# 	let "i=${input}"
# 	# FIXME: subtract 1 from the second sequence so that you do not repeat the same search
# 	partial_search=$(sed -n "${seqs[$i]}","${seqs[$((i + 1))]}"p "$clean_repeats_file");
# 	for search in $partial_search; do
# 		# FIXME: check if count is not null then echo to output file
# 		count=$(grep -o $search $genome_file | uniq -c);
# 		echo "$genome_file $count" >> $output_file;
# 	done
# }
# 
# for i in $(seq 0 1 $((seqs_length - 2))); do
# 	process_child $i &
# done

echo_info
