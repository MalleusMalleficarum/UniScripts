#!/bin/bash
while getopts 'e:d:' OPTION ; do
    case "$OPTION" in
	e)
	    printf "Experiment:\t\t $OPTARG \n"
	    experiment=$OPTARG;;

	d)
	    printf "Workspace path:\t\t $OPTARG \n"
	    workpath=$OPTARG;;
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
printf "Experiment name: $experiment \n"
printf "Workspace path: $workpath \n"
./create_experiments.sh "-e$experiment" "-d$workpath"
./bwcluster_start_parbatch.sh "-e$experiment" "-d$workpath"
