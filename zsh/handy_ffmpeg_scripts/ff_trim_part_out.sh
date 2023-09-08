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

# Output video file
output_file="out_part_trimmed__$NOW.mkv"

# Start and end times in seconds
start_time="$START"
end_time="$END"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file '$input_file' not found."
  exit 1
fi

# Cut the video using FFmpeg with parameterized start and end times
ffmpeg -i "$input_file" -vf "select='not(between(t,$start_time,$end_time))',setpts=N/FRAME_RATE/TB" -af "aselect='not(between(t,$start_time,$end_time))',asetpts=N/SR/TB" "$output_file"

# Check if FFmpeg was successful
if [ $? -eq 0 ]; then
  echo "Video cut complete. Output saved as '$output_file'."
else
  echo "Video cut failed."
fi
