#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
  echo "FFmpeg is not installed. Please install it first."
  exit 1
fi

# Check if env vars are set and non-empty
if [ -z "$INPUT_MP3" ] || [ -z "$INPUT_IMG" ] ; then
  echo "Required: INPUT_MP3, INPUT_IMG."
  exit 1
fi

# current date and time
NOW=$(date '+%F_%H-%M-%S')

# Input MP3 audio file
input_file="$INPUT_MP3"

# Output MP3 audio file with added image
output_file="out_with_image__$NOW.mp3"

# Image file (e.g., album art)
image_file="$INPUT_IMG"

# Check if the input file and image file exist
if [ ! -f "$input_file" ]; then
  echo "Input file '$input_file' not found."
  exit 1
fi

if [ ! -f "$image_file" ]; then
  echo "Image file '$image_file' not found."
  exit 1
fi

# Add image and metadata using FFmpeg
ffmpeg -i "$input_file" -i "$image_file" -map 0 -map 1 -c copy -id3v2_version 3 "$output_file"

# Check if FFmpeg was successful
if [ $? -eq 0 ]; then
  echo "Image and metadata added. Output saved as '$output_file'."
else
  echo "Image and metadata addition failed."
fi
