#!/usr/bin/env bash
# Convert MKV to GIF
# Inspired almost entirely by https://github.com/rickycodes/retrorecord/blob/master/mkvToGif.sh
# A few tweaks here and there, but the logic (and var names for the most part) are the same

#set -e

# Make sure command is installed and in the path
declare -a COMMANDS=("ffmpeg" "gifski")
for i in "${COMMANDS[@]}"
do command -v "$i">/dev/null 2>&1 || {
  echo "- - Exiting Early - -"
  echo $i "is required for conversion, please install it and ensure that it is in your path"
  exit 1
  }
done

# Set paths for required tools
FFMPEG_PATH=$(which ffmpeg)
GIFSKI_PATH=$(which gifski)

# MKV file to convert - first argument after mkv2gif.sh
if [ -z "$1" ]
  then
    echo "Need at least one argument: MKV file to convert"
    echo 'USAGE: ./mkv2gif.sh FILE PATH [FPS] [SCALE] [FRAMES BEFORE END OF MKV]'
    exit 1
elif [[ ! -e $1 ]]
  then
    echo "$1: file not found"
    exit 1
else
  FILE=$1
fi

# Second argument after mkv2gif.sh
MKV_PATH_DEFAULT="$(pwd)"
MKV_PATH=${2:-`echo $MKV_PATH_DEFAULT`}

# Our GIF frames per second
FPS_DEFAULT=10
FPS=${3:-$FPS_DEFAULT}

# Our scale, argument four if present
SCALE_DEFAULT=400
SCALE=${4:-$SCALE_DEFAULT}

# Frames before the end of MKV to use
FRAMES_DEFAULT=10
FRAMES=${5:-$FRAMES_DEFAULT}
DURATION=$FRAMES # Use the same duration as frames

# Remove intermediate files
function cleanup () {
  /bin/rm "${MKV_PATH}"/"$1"*.png
  #rm "${MKV_PATH}"
}

# Convert each MKV frame to PNG
"${FFMPEG_PATH}" -sseof -"${FRAMES}" \
  -t "${DURATION}" \
  -i "${FILE}" \
  -vf scale="${SCALE}":-1:flags=lanczos,fps="${FPS}" \
  "${MKV_PATH}"/"${1}"_ffout%03d.png || {
    echo 'Conversion failed, exiting!'
    exit 1
  }

# Convert PNGs to GIF
"${GIFSKI_PATH}" "${MKV_PATH}"/"${1}"_ffout*.png \
  --fps $FPS \
  -o "${MKV_PATH}"/"$1"_output.gif || {
    echo 'GIF conversion failed, exiting!'
    cleanup
    exit 1
  }

echo "GIF created at" $MKV_PATH"/"$1"_output.gif!"
cleanup
