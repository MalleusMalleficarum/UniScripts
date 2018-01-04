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
# [X] set CONFERENCE in common_setup.sh

#instance directory hmetisrb_remaining
#INSTANCE_DIR="/work/workspace/scratch/mp6747-alenex15-0/sat_instances/"
INSTANCE_DIR="/work/workspace/scratch/uleci-evo_instance-0/"
###########################

###########################
# Scripts to start partitioners
###########################
#declare -a start_scripts=("$PWD/start_kahypar_ml.py" "$PWD/start_kahypar_evo.py") #Not clever if i want to run multiple evo and one nonevo
declare -a start_scripts=("$PWD/start_kahypar_evo.py")
###########################

for partitioner in "${start_scripts[@]}"
do
    for instance in $INSTANCE_DIR/*.hgr;
    do
	COUNTER=`showq | egrep "Running|Idle|Deferred" | wc -l`
	echo "queue has $COUNTER $MAXQUEUEVALUE"
	while [ $COUNTER -ge $MAXQUEUEVALUE ] 
	do 
            echo "waiting to submit"
            sleep 30s
            COUNTER=`showq | egrep "Running|Idle|Deferred" | wc -l`
            echo queue has $COUNTER
	done

	###################################
	# can be used for testing:
	#./bwclusterwrapper.sh "./start_all_k_all_iterations_wrapper.sh -s $partitioner -i /work/workspace/scratch/mp6747-esa15-0/instances/ISPD98_ibm01.hgr"
	msub -q singlenode -l nodes=1:ppn=16,pmem=62gb,walltime=00:12:00:00,naccesspolicy=singlejob ./bwclusterwrapper.sh "./start_all_k_all_iterations_wrapper.sh -s $partitioner -i $instance"
	###################################
	
	###################################
	# standard config
	###################################
        #msub -q singlenode -l nodes=1:ppn=1,pmem=62gb,walltime=02:00:00:00,naccesspolicy=singlejob ./bwclusterwrapper.sh "./start_all_k_all_iterations_wrapper.sh -s $partitioner -i $instance"
	#sleep 5s
	
    done
done
