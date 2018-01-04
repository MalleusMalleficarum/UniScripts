#!/bin/bash

while getopts 's:i:k:b:e:f:' OPTION ; do
    case "$OPTION" in
	s)
	    printf "Script:\t $OPTARG \n"
	    START_SCRIPT=$OPTARG;;
	i)
	    printf "Instance:\t $OPTARG \n"
	    INSTANCE=$OPTARG;;
	k)
	    printf "k:\t $OPTARG \n"
	    K=$OPTARG;;
	b)
	    printf "b:\t $OPTARG \n"
	    B=$OPTARG;;
	e)
	    printf "e:\t $OPTARG \n"
	    E=$OPTARG;;
        f)
	    printf "f:\t $OPTARG \n"
	    F=$OPTARG
    esac
done

if [ "x" == "x$START_SCRIPT" ]; then
  echo "-s [option] is required: start script"
  exit
fi

if [ "x" == "x$INSTANCE" ]; then
  echo "-i [option] is required: hypergraph instance"
  exit
fi

if [ "x" == "x$K" ]; then
  echo "-i [option] is required: k"
  exit
fi

if [ "x" == "x$B" ]; then
  echo "-i [option] is required: B seed"
  exit
fi

if [ "x" == "x$E" ]; then
  echo "-i [option] is required: E seed"
  exit
fi

if [ "x" == "x$F" ]; then
  echo "-i [option] is required: F epsilon"
  exit
fi

source common_setup.sh

k=$K
#seed=$SEED

module load lib/boost/1.55.0
module load compiler/gnu/5.2

###########################
# Experimental Setup
###########################
epsilon=$F
###########################
for seed in `seq $B $E`
do 
    $START_SCRIPT $INSTANCE $k $epsilon $seed >> "$GRAPH_NAME.$k.$epsilon.$seed.results"
done
