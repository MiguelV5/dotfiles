#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
  echo "FFmpeg is not installed. Please install it first."
  exit 1
fi

# Check if env vars are set and non-empty
if [ -z "$INPUT_VID" ]; then
  echo "Required: INPUT_VID."
  exit 1
fi

# current date and time
NOW=$(date '+%F_%H-%M-%S')

# Input video file
input_file="$INPUT_VID"

# Output compressed video file
output_file="out_compressed__$NOW.mkv"

# Video bitrate (adjust as needed, lower values mean higher compression)
video_bitrate="1000k"

# Audio codec (use "aac" for better compatibility)
audio_codec="aac"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Input file '$input_file' not found."
  exit 1
fi

# Compress the video using FFmpeg
ffmpeg -i "$input_file" -b:v "$video_bitrate" -c:v libx264 -preset slow -c:a "$audio_codec" "$output_file"

# Check if FFmpeg was successful
if [ $? -eq 0 ]; then
  echo "Video compression complete. Output saved as '$output_file'."
else
  echo "Video compression failed."
fi
