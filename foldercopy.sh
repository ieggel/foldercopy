#!/bin/bash

#Define help string
help='Usage: foldercopy [OPTION]... [DEST_DIR] 
This script copies the current folder to a destination folder.
Options:
  -i           include files (type f) in root dir
               default=false
  -e=pattern   exclude files (pattern compatible with find)
'

#Check num args not less than 1
if [ $# -lt 1 ]
  then
    echo "$help"
    exit 1
fi

#Default value for -i argument
include_files=false

#Last arg 
dest_dir=${@: -1:1}

#Loop through remaining parameters: 1 to (length-1) and assign
for arg in ${@:1:$#-1}
do
    key=$(echo $arg | cut -f1 -d=)
    val=$(echo $arg | cut -f2 -d=)   

    case "$key" in
            -i)    include_files=true ;;
            -e)    exclude_pattern=${val} ;;
             *)   
    esac    
done

echo $include_files
echo $exclude_pattern

use_exclude_pattern=false
if [[ ! -z "${exclude_pattern}" ]]
  then
    use_exclude_pattern=true
fi

# Print info
echo "Include files: ${include_files}. Use exclude pattern: ${use_exclude_pattern}."
if [[ $use_exclude_pattern = true ]]
  then
    echo "Pattern: $exclude_pattern"
fi
echo "Copying to destination dir: ${dest_dir}"


# include root files and use exclude pattern
if [[ $include_files = true && ! -z "${exclude_pattern}" ]]
  then
    find . -type f -regextype posix-egrep -not -regex "$exclude_pattern" -exec cp --parent '{}' "$dest_dir" ';'
# do not include root files and use exclude pattern
elif [[ $include_files = false && ! -z "${exclude_pattern}" ]]
  then
    all_dirs=$(find . -type d)
    for dir in ${all_dirs}
    do
      if [[ ! $dir = '.' ]]
        then
           find $dir -type f -regextype posix-egrep -not -regex "$exclude_pattern" -exec cp --parent '{}' "$dest_dir" ';'
      fi   
    done
# include root files and do not use exclude pattern
elif [[ $include_files = true &&  -z "${exclude_pattern}" ]]
  then
    find . -type f -exec cp --parent '{}' "$dest_dir" ';'
# do not include root files and do not use exclude pattern
elif [[ $include_files = false &&  -z "${exclude_pattern}" ]]
  then
    all_dirs=$(find . -type d)
    for dir in ${all_dirs}
    do
      if [[ ! $dir = '.' ]]
        then
           find $dir -type f -exec cp --parent '{}' "$dest_dir" ';'
      fi   
    done
fi
