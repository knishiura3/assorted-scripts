#!/bin/bash
# rapidly deduplicate repeated ids in two columns of one file with awk associative array. 
# no need to pre-sort data

# usage:    dedupe.sh <delimiter> <field1> <field2> <filename>
# or pipe in:    <stdin> | dedupe.sh <delimiter> <field1> <field2>

# example input data.txt:
# id1 id2 data
# a b 4
# a c 1
# a d 6
# b a 4
# b c 2
# b d 3
# c a 1
# c b 2
# c d 5
# d a 6
# d b 3
# d c 5

# expected output:
# id1 id2 data
# a b 4
# a c 1
# a d 6
# b c 2
# b d 3
# c d 5

if [ -f "${4}" ]; then
    LC_ALL=C awk -F"${1}" -v field1="${2}" -v field2="${3}" '!seen[$field1,$field2]++ && !seen[$field2,$field1]++' "${4}"
else
if [ -p /dev/stdin ]; then
    LC_ALL=C awk -F"${1}" -v field1="${2}" -v field2="${3}" '!seen[$field1,$field2]++ && !seen[$field2,$field1]++'
else
    printf "Usage:\ndedupe.sh <delimiter> <field1> <field2> <filename>\nor pipe in: <stdin> | dedupe.sh <delimiter> <field1> <field2>\n"
fi
fi
