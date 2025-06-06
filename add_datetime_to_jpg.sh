#!/bin/bash

if [[ -z $1 ]]; then
  echo "usage: $0 <input.jpg> <output.jpg>"
  exit 127
fi

if [[ -z $2 ]]; then
  echo "usage: $0 <input.jpg> <output/dir>"
  exit 127
fi

INPUT="$1"
BASENAME=$(basename "$INPUT")
OUTPUT="$2/${BASENAME}"

datetime=${BASENAME#timelapse_}
datetime=${datetime%.jpg}
date_part=${datetime%_*}
time_part=${datetime#*_}
time_part=${time_part//-/:}
datetime="$date_part $time_part"

convert "${INPUT}" -fill green -pointsize 90 -weight bold -annotate +10+90 "$datetime" ${OUTPUT}
