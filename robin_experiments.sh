#!/bin/bash
INSTANCE_DIR="/work/workspace/scratch/zd6360-hmetis-0/instances/paper_subset"
#INSTANCE_DIR="/home/andre/server-home/Hypergraphs/benchmark_subset"
EXECUTABLE_DIR="/home/kit/iti/zd6360/application/kahypar-1/release/kahypar/application"
CONFIG_DIR="/home/kit/iti/zd6360/application/kahypar-1/config"
while getopts 'e:d:f:r:' OPTION ; do
    case "$OPTION" in
	e)
	    printf "Experiment:\t\t $OPTARG \n"
	    experiment=$OPTARG;;

	d)
	    printf "Workspace path:\t\t $OPTARG \n"
	    workpath=$OPTARG;;
       	f)
	    printf "Task File Link:\t\t $OPTARG \n"
	    bigfile=$OPTARG;;
        r)
	    printf "Result Directory:\t\t $OPTARG \n"
	    resultdir=$OPTARG;;
    esac
done

if [ "x" == "x$experiment" ]; then
  echo "-e [option] experiment name is required"
  exit
fi

if [ "x" == "x$workpath" ]; then
    echo "-d [option] workspace path is required"
  exit
fi

RANDOM_MUTATION=0
RANDOM_COMBINE=1
RANDOM_CROSS_COMBINE=0
MUTATION_CHANCE=0.5
CROSS_COMBINE_CHANCE=0
TIME_LIMIT=28800
LOG_OUTPUT=1
MUTATE_STRATEGY="new-initial-partitioning-vcycle"
COMBINE_STRATEGY="basic"
CROSS_COMBINE_STRATEGY="k"
POPULATION_SIZE=10
REPLACE_STRATEGY="strong-diverse"
EDGE_FREQUENCY_INTERVAL=-1
DIVERSIFY_INTERVAL=1
EPSILON=0.03
declare -a kValues=("2" "4" "8" "16" "32" "64" "128") 

for instance in $INSTANCE_DIR/*.hgr;
		
do
    echo $instance
    for seed in `seq 1 5`
    do
	echo $seed
	for k in "${kValues[@]}"
        do
	    echo $k

	    RAW_INSTANCE="${instance##*/}"
	    LOG_FILE="$resultdir/log/$RAW_INSTANCE.$k.$seed"
	    
            echo "$resultdir/log/$RAW_INSTANCE.$k.$seed" >> $LOG_FILE #creates the seperate log files
	    echo $RAW_INSTANCE
	    echo $LOG_FILE

	    #Generate the commands for the parbatch scripts here
	    #
	    echo "$EXECUTABLE_DIR/./KaHyParE -h $instance -k $k -e $EPSILON -o km1 -m direct -p $CONFIG_DIR/km1_direct_kway_sea17.ini --seed=$seed --diversify-interval=$DIVERSIFY_INTERVAL --replace-strategy=$REPLACE_STRATEGY --population-size=$POPULATION_SIZE --cross-combine-strategy=$CROSS_COMBINE_STRATEGY --combine-strategy=$COMBINE_STRATEGY --mutate-strategy=$MUTATE_STRATEGY --log-output=$LOG_OUTPUT --time-limit=$TIME_LIMIT --cross-combine-chance=$CROSS_COMBINE_CHANCE --mutate-chance=$MUTATION_CHANCE --filename=$LOG_FILE --random-mutate=$RANDOM_MUTATION --random-combine=$RANDOM_COMBINE --random-cross-combine=$RANDOM_CROSS_COMBINE --edge-frequency-chance=0.5 --q=1 --random-vcycles=1" >> $bigfile
	    done
	
    done
done
#

