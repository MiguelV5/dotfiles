#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
  echo "FFmpeg is not installed. Please install it first."
  exit 1
fi

# Check if env vars are set and non-empty
if [ -z "$INPUT_VID" ]; then
  echo "Required: INPUT_VID"
  exit 1
fi

# current date and time
NOW=$(date '+%F_%H-%M-%S')

# Input MKV video file
input_file="$INPUT_VID"

# Output MP3 audio file
output_file="out_extracted__$NOW.mp3"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file '$input_file' not found."
  exit 1
fi

# Convert MKV to MP3 using FFmpeg
ffmpeg -i "$input_file" -vn -acodec libmp3lame -q:a 0 "$output_file"

# Check if FFmpeg was successful
if [ $? -eq 0 ]; then
  echo "Conversion complete. Output saved as '$output_file'."
else
  echo "Conversion failed."
fi
