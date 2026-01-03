#!/bin/bash

# Check that at least one argument was provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <input_file1> <input_file2> ..."
    exit 1
fi

# Loop through all arguments (input files)
for input_file in "$@"; do
    # Get file name and extension
    input_file_name=$(basename "$input_file")
    input_file_extension="${input_file_name##*.}"
    input_file_name="${input_file_name%.*}"

    # Set output file name
    output_mp4="${input_file_name}-converted.mp4"

    echo "Converting $input_file -> $output_mp4"

    # Run ffmpeg command to convert MOV -> MP4
    ffmpeg -i "$input_file" -c:v libx264 -crf 23 -preset fast -c:a aac -b:a 192k "$output_mp4"

    echo "Conversion complete: $output_mp4"
done

