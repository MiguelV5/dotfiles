#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
  echo "FFmpeg is not installed. Please install it first."
  exit 1
fi

# Check if env vars are set and non-empty
if [ -z "$P1" ] || [ -z "$P2" ]; then
  echo "Required: P1, P2."
  exit 1
fi

# current date and time
NOW=$(date '+%F_%H-%M-%S')

# Manufactured Inputs txt file for ffmpeg
touch join.txt

echo "file $PWD/$P1" > join.txt

echo "file $PWD/$P2" >> join.txt

input_file="join.txt"

# Output file name
output_file="out_concat__$NOW.mkv"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file '$input_file' not found."
  exit 1
fi

# Concatenate the MKV files
ffmpeg -f concat -safe 0 -i "$input_file" -c copy "$output_file"

# Check if FFmpeg was successful
if [ $? -eq 0 ]; then
  echo "Concatenation complete. Output saved as '$output_file'."
else
  echo "Concatenation failed."
fi

rm join.txt

