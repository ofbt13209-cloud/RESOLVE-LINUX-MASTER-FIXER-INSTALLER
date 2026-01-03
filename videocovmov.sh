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
    output_mov="${input_file_name}-converted.mov"

    echo "Converting $input_file -> $output_mov"

    # Run ffmpeg
    ffmpeg -i "$input_file" -c:v mpeg4 -q:v 2 -c:a pcm_s16le -f mov "$output_mov"

    echo "Conversion complete: $output_mov"
done

