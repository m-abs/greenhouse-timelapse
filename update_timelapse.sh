#!/bin/bash

if [[ -z $1 ]]; then
  echo "usage $0 <url> <target_folder> <email@address>"
  exit 127
fi

if [[ -z $2 ]]; then
  echo "usage $0 <url> <target_folder> <email@address>"
  exit 127
fi

if [[ -z $3 ]]; then
  echo "usage $0 <url> <target_folder><email@address>"
  exit 127
fi

URL=$1
OUTPUT_BASE_PATH=$2
ERROR_MAIL=$3
FILE_LIST="${OUTPUT_BASE_PATH}/file_list.txt"

OUTPUT_DIR="${OUTPUT_BASE_PATH}/$(date +"%Y-%m-%d")"
OUTPUT_DATE_VIDEO="${OUTPUT_DIR}/day.mkv"
OUTPUT_VIDEO_PATH="${OUTPUT_BASE_PATH}/timelapse.mkv"

LOG_FILE="${OUTPUT_BASE_PATH}/timelapse.log"

set -e

function SendErrorMail {
  local subject="Timelapse Update Error"
  echo "Update timelapse failed!" | tee -a ${LOG_FILE}

  cat ${LOG_FILE} | mail -s $subject ${ERROR_MAIL}
  exit 1
}
 
mkdir -p ${OUTPUT_DIR}

# Prime the camera
for I in {1..3}; do
  curl "${URL}" --output /dev/null -s
done

# Take the photo
if ! wget -P "${OUTPUT_DIR}" "${URL}" --content-disposition -a ${LOG_FILE}; then
  SendErrorMail
fi

# Make the timelapse video of the day
if ! ffmpeg \
  -framerate 25 \
  -pattern_type glob \
  -i "${OUTPUT_DIR}/*.jpg" \
  -c:v hevc \
  -crf 0 \
  -y "${OUTPUT_DATE_VIDEO}" \
  -loglevel info 2>> ${LOG_FILE}; then
  SendErrorMail
fi

# Concatenate the daily video into the main timelapse video

## Make the file list for ffmpeg
(
  cd "${OUTPUT_BASE_PATH}" && \
  find . -mindepth 2 -name "*.mkv" |\
  sort |\
  xargs -i echo "file '{}'"
) > ${FILE_LIST}

## Concat the videos
if ! ffmpeg \
  -f concat \
  -safe 0 \
  -i ${FILE_LIST} \
  -c copy \
  -y ${OUTPUT_VIDEO_PATH} \
  -loglevel info 2>> ${LOG_FILE}; then
  SendErrorMail
fi
