#!/bin/bash
# uses awk associative array to look up values from a lookup file and substitute them in another file
# usage: awk_lookup.sh <delimiter> <lookup field1> <lookup field2> <data field> <lookup file> <data file>
# if --alignall flag is set, then set default values for use with mmseqs alignall output,
# and supply lookup and datafiles
# usage:  awk_lookup.sh <lookup file> <data file>

if [ "$#" -eq 6 ]; then
    # store lookup columns as key:value pairs in associative array
    # replace data column with key:value substitution from lookup array
    LC_ALL=C awk -F "${1}" -v lookup1="${2}" -v lookup2="${3}" -v data1="${4}" 'FNR==NR{array[$lookup1]=$lookup2;next}{$data1=array[$data1]; print}' "${5}" "${6}"
else
# default settings for use with mmseqs alignall output
if [ "$1" == "--alignall" ] || [ "$2" == "--alignall" ] || [ "$3" == "--alignall" ] || [ "$4" == "--alignall" ] || [ "$5" == "--alignall" ] || [ "$6" == "--alignall" ]; then
    LC_ALL=C awk -F "\t" 'FNR==NR{array[$1]=$2;next}{$3=array[$3]; print}' "${5}" "${6}"
else
    printf "usage:\nawk_lookup.sh <delimiter> <lookup field1> <lookup field2> <data field> <lookup file> <data file>\nif --alignall flag is set, then set default values for use with mmseqs alignall output,\nand supply lookup and datafiles\nusage w/ mmseqs alignall:  awk_lookup.sh <lookup file> <data file>\n"
fi
fi

