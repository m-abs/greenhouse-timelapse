#!/bin/bash

set -e
if [[ -z $1 ]]; then
    echo "usage: $0 <output_dir> <output_video_path> <log_file>"
    exit 127
fi

if [[ -z $2 ]]; then
    echo "usage: $0 <output_dir> <output_video_path> <log_file>"
    exit 127
fi

if [[ -z $3 ]]; then
    echo "usage: $0 <output_dir> <output_video_path> <log_file>"
    exit 127
fi

OUTPUT_DIR="$1"
OUTPUT_DATE_VIDEO="$2"
LOG_FILE="$3"

ffmpeg \
    -framerate 25 \
    -pattern_type glob \
    -i "${OUTPUT_DIR}/*.jpg" \
    -c:v hevc \
    -crf 0 \
    -y "${OUTPUT_DATE_VIDEO}" \
    -loglevel info 2>>${LOG_FILE}

exit $?
