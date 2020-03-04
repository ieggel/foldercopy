#!/bin/bash



for arg in "$@"
do

    key=$(echo $arg | cut -f1 -d=)
    val=$(echo $arg | cut -f2 -d=)   

    case "$KEY" in
            --include_folders    include_folders=${val} ;; 
            --exclude_root_files  exclude_root_files=${val} ;; 
            *)   
    esac    


done

echo "STEPS = $STEPS"
echo "REPOSITORY_NAME = $REPOSITORY_NAME"

root_folder=$1
echo $root_folder
folders=(centre_0 centre_1 centre_2 centre_3 centre_4 centre_4_new)

for i in ${folders[@]}
do
 echo $i

done
