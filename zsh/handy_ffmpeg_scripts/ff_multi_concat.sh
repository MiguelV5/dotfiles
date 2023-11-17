#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
	echo "FFmpeg is not installed. Please install it first."
	exit 1
fi

# Check if env vars are set and non-empty
if [ -z "$N" ]; then
	echo "Required definition of N env var (last vid idx to concat)."
	echo "[WARNING]: Properly rename the video files to concatenate in order as:  p1.<extension>, p2.<extension>... and so on."
	exit 1
fi
if [ -z "$EXTENSION" ]; then
	echo "EXTENSION not defined. Using default (mkv)"
	EXTENSION="mkv"
fi

# current date and time
NOW=$(date '+%F_%H-%M-%S')

# Manufactured Inputs txt file for ffmpeg
touch join.txt

echo "file $PWD/p1.$EXTENSION" > join.txt
for ((idx=2;idx<=N;idx++)); do
	echo "file $PWD/p$idx.$EXTENSION" >> join.txt
done

input_file="join.txt"

# Output file name
output_file="out_concat__$NOW.$EXTENSION"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file '$input_file' not found."
  exit 1
fi

# Concatenate the files
ffmpeg -f concat -safe 0 -i "$input_file" -c copy "$output_file"

# Check if FFmpeg was successful
if [ $? -eq 0 ]; then
  echo "Concatenation complete. Output saved as '$output_file'."
else
  echo "Concatenation failed."
fi

rm join.txt
