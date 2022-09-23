#!/bin/bash

# quick descriptive stats on the command line
# usage: stats.sh <file>
# example: stats.sh data.txt
# example (piped in from stdin):
#     awk '{print $2}' data.txt | stats.sh
# outputs: sum count average median min max


if [ -p /dev/stdin ]; then
echo -e "sum\tcount\taverage\tmedian\tmin\tmax"
sort -n | awk '
    BEGIN {
        count = 0;
        sum = 0;
    }
    $1 ~ /^(\-)?[0-9]*(\.[0-9]*)?$/ {
        array[count++] = $1;
        sum += $1;
    }
    END {
        ave = sum / count;
        if( (count % 2) == 1 ) {
            median = array[ int(count/2) ];
        } else {
            median = ( array[count/2] + array[count/2-1] ) / 2;
        }
        OFS="\t";
        print sum, count, ave, median, array[0], array[count-1];
    }
'
else
if [ -f "$1" ]; then
echo "Filename specified: ${1}"
echo -e "sum\tcount\taverage\tmedian\tmin\tmax"
sort -n "${1}" | awk '
    BEGIN {
        count = 0;
        sum = 0;
    }
    $1 ~ /^(\-)?[0-9]*(\.[0-9]*)?$/ {
        array[count++] = $1;
        sum += $1;
    }
    END {
        ave = sum / count;
        if( (count % 2) == 1 ) {
            median = array[ int(count/2) ];
        } else {
            median = ( array[count/2] + array[count/2-1] ) / 2;
        }
        OFS="\t";
        print sum, count, ave, median, array[0], array[count-1];
    }
'
else
    echo "No input. Feed me one number per line in a text file or pipe them in."
    echo "Try stats.sh <file> or pipe in from stdin."
fi
fi
