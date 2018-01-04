#!/bin/bash

while getopts 'e:t:d:' OPTION ; do
    case "$OPTION" in
	e)
	    printf "Experiment:\t\t $OPTARG \n"
	    experiment=$OPTARG;;
	t)
	    printf "Tag:\t\t $OPTARG \n"
	    tag=$OPTARG;;
	d)
	    printf "Workpath:\t\t $OPTARG \n"
	    workpath=$OPTARG;;

	    esac

done

if [ "x" == "x$experiment" ]; then
  echo "-e [option] is required"
  exit
fi
if [ "x" == "x$tag" ]; then
  echo "-t [option] is required"
  exit
fi
if [ "x" == "x$workpath" ]; then
  echo "-d [option] is required"
  exit
fi




###########################
INSTANCE_DIR="/home/kit/iti/zd6360/instances/tuning_subset"
#INSTANCE_DIR="/home/andre/server-home/Hypergraphs/benchmark_subset"
EXECUTABLE_DIR="/home/kit/iti/zd6360/application/kahypar-1/release/kahypar/application"
CONFIG_DIR="/home/kit/iti/zd6360/application/kahypar-1/config"
bigfile=$workpath$experiment/taskfile
touch $bigfile
cd $INSTANCE_DIR
#mkdir "/home/andre/server-global_data/schlag/in_out/robin_local_results/$experiment/"
for instance in $INSTANCE_DIR/*.hgr 
do 
for seed in `seq 1 5`
do
if [ ! -d $workpath$experiment ] 
	then
		mkdir $workpath$experiment 
fi
if [ ! -d $workpath$experiment/$tag ]
  then 
    mkdir $workpath$experiment/$tag
fi 
RAW_INSTANCE="${instance##*/}"

touch "$workpath$experiment/$tag/$RAW_INSTANCE.$seed"
#touch "/home/andre/server-home/Hypergraphs/tuning/results/$experiment/$threshold/$instance.$seed.t_is_one"

  echo $EXECUTABLE_DIR/./KaHyParE -h $INSTANCE_DIR/$RAW_INSTANCE -k 32 -e 0.03 -o km1 -m direct -p $CONFIG_DIR/km1_direct_kway_sea17.ini --q=1 --log-output=1 --filename=$workpath$experiment/$tag/$RAW_INSTANCE.$seed --mutate-chance=0.4 --cross-combine-chance=0 --combine-strategy=basic --mutate-strategy=new-initial-partitioning-vcycle --cross-combine-strategy=louvain --population-size=10 --seed=$seed --time-limit=7200  --dynamic-population=1 --random-combine=1 --random-mutate=0 --random-cross-combine=0 --random-vcycles=0 --edge-frequency-chance=1 >> $bigfile

done
done





