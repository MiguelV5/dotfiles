#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
  echo "FFmpeg is not installed. Please install it first."
  exit 1
fi

# Check if env vars are set and non-empty
if [ -z "$INPUT_VID" ] || [ -z "$START" ] || [ -z "$END" ]; then
  echo "Required: INPUT_VID, START, END."
  exit 1
fi

# current date and time
NOW=$(date '+%F_%H-%M-%S')

# Input video file
input_file="$INPUT_VID"

# Output cut video file
output_file="out_clipped__$NOW.mkv"

# Start and end times in seconds
start_time="$START"
end_time="$END"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file '$input_file' not found."
  exit 1
fi

# Cut the video using FFmpeg with specified start and end times
ffmpeg -ss "$start_time" -i "$input_file" -to "$end_time" -c copy "$output_file"

# Check if FFmpeg was successful
if [ $? -eq 0 ]; then
  echo "Video clip extraction complete. Output saved as '$output_file'."
else
  echo "Video clip extraction failed."
fi
