#!/bin/bash
MAXQUEUEVALUE=49

###########################
# CHANGE THESE:
# environment variables used in python scripts
# export PATOH_BINARY="/software/patoh-Linux-x86_64/Linux-x86_64/patoh"
# export HMETIS_BINARY="/home/schlag/hmetis-2.0pre1/Linux-x86_64/hmetis2.0pre1"
# export PATOH_TMP="/tmp"

#TODO:
# [X] set PaToH in start_patoh.py
# [X] set PATOH_TMP in start_patoh.py
# [X] set hMetis in start_hmetiskway.py
# [X] set hMetis in start_hmetisrb.py
# [ ] set CONFERENCE in common_setup.sh

###########################



###########################
# Scripts to start partitioners
###########################
#declare -a start_scripts=("$PWD/start_kahypar_ml.py")
#declare -a start_scripts=("$PWD/start_soed_hmetisrb.py")
#declare -a start_scripts=("$PWD/start_patohdefault.py")
#declare -a start_scripts=("$PWD/start_hmetisrb.py")
#declare -a start_scripts=("$PWD/start_kahypar-partial.py" "$PWD/start_kahypar-full.py" "$PWD/start_kahypar-partial-nocache.py"  "$PWD/start_kahypar-full-nocache.py"  "$PWD/start_kahypar-lazy-nocache.py")
declare -a start_scripts=("$PWD/start_kahypar_bipartite-hybrid.py")
###########################

declare -a kValues=("64" "128")

seedbeg=1
seedend=10

epsilon=0.03

for partitioner in "${start_scripts[@]}"
do
    COUNTER=`showq | egrep "Running|Idle" | wc -l`
    echo "queue has $COUNTER $MAXQUEUEVALUE"
    while [ $COUNTER -ge $MAXQUEUEVALUE ] 
    do 
        echo "waiting to submit"
        sleep 10s
        COUNTER=`showq | egrep "Running|Idle" | wc -l`
        echo queue has $COUNTER
    done
    
    for k in "${kValues[@]}"
    do
	for seed in `seq $seedbeg $seedend`
	do
	    ###standard config
            msub -q singlenode -l nodes=1:ppn=1,pmem=60gb,walltime=02:00:00:00,naccesspolicy=singlejob ./bwclusterwrapper.sh "./start_single_k_single_iteration_script.sh -s $partitioner -i /work/workspace/scratch/mp6747-sea17_benchmark_subset-0/sat14_atco_enc3_opt1_04_50.cnf.dual.hgr -k $k -b $seed -e $seed -f $epsilon"
	    #sleep 2s
	done
    done
done

