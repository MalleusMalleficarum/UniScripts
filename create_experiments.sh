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
if [ -d "$experiment" ]; then
    echo "directory already exists..."
    exit
fi
mkdir "$workpath$experiment"
BIG_FILE="$workpath$experiment/task_file"
RESULT_DIR="$workpath$experiment"
echo >> $BIG_FILE
mkdir "$RESULT_DIR/jobs"
mkdir "$RESULT_DIR/log"

# Here you have to put your script that fills the BIG_FILE with
# All the experiment calls 
#./yourscripthere.sh -i $BIG_FILE

./robin_experiments.sh "-e$experiment" "-d$workpath" "-f$BIG_FILE" "-r$RESULT_DIR"
cd "$RESULT_DIR/jobs"
split $BIG_FILE -l 16 -d
