#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
  echo "FFmpeg is not installed. Please install it first."
  exit 1
fi

# Check if env vars are set and non-empty
if [ -z "$INPUT_VID" ] || [ -z "$W" ] || [ -z "$H" ] || [ -z "$X" ] || [ -z "$Y" ]; then
  echo "Required: INPUT_VID, W, H, X, Y."
  exit 1
fi

# current date and time
NOW=$(date '+%F_%H-%M-%S')

# Input video file
input_file="$INPUT_VID"

# Output video file
output_file="out_cropped__$NOW.mkv"

# Crop parameters (width, height, x-coordinate, y-coordinate)
crop_width="$W"
crop_height="$H"
crop_x="$X"
crop_y="$Y"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file '$input_file' not found."
  exit 1
fi

# Crop the video using FFmpeg
ffmpeg -i "$input_file" -vf "crop=$crop_width:$crop_height:$crop_x:$crop_y" "$output_file"

# Check if FFmpeg was successful
if [ $? -eq 0 ]; then
  echo "Cropping complete. Output saved as '$output_file'."
else
  echo "Cropping failed."
fi
