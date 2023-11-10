#!/bin/bash

# WARNING: manually set the END env var before using the script.
# Also, properly rename the video files to concatenate in order as p1.<extension>, p2.<extension>... and so on.

# current date and time
NOW=$(date '+%F_%H-%M-%S')

# Manufactured Inputs txt file for ffmpeg
touch join.txt

END=8
echo "file $PWD/p1.mp4" > join.txt
for ((idx=2;idx<=END;idx++)); do
	echo "file $PWD/p$idx.mp4" >> join.txt
done

input_file="join.txt"

# Output file name
output_file="out_concat__$NOW.mkv"

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
