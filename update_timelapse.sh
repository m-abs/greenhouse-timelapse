#!/bin/bash

if [[ -z $1 ]]; then
  echo "usage $0 <url> <target_folder>"
  exit 127
fi

if [[ -z $2 ]]; then
  echo "usage $0 <url> <target_folder>"
  exit 127
fi

URL=$1
OUTPUT_PATH=$2

set -e
 
mkdir -p $OUTPUT_PATH

wget -P "${OUTPUT_PATH}" "${URL}" --content-disposition -a $OUTPUT_PATH/timelapse.log

ffmpeg -framerate 10 -pattern_type glob -i "${OUTPUT_PATH}/*.jpg" -c:v hevc -crf 0 -y "${OUTPUT_PATH}/timelapse.mkv" -loglevel info 2>> $OUTPUT_PATH/timelapse.log

