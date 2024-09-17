#!/bin/bash

# Function to install FFMPEG
install_ffmpeg() {
    # I know many distros have shortened apt-get to just apt, but I'm keeping apt-get for backwards-compatibility with older distros
    echo "FFMPEG not found. Installing..."
    sudo apt-get update && sudo apt-get install -y ffmpeg
}

# Check if FFMPEG is installed
if ! command -v ffmpeg &> /dev/null; then
    install_ffmpeg
fi

# Check for input directory
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Find MP4 and M4A files
mapfile -t files < <(find "$1" -type f \( -iname "*.mp4" -o -iname "*.m4a" \))
total_files=${#files[@]}
counter=0

for file in "${files[@]}"; do
    output="${file%.*}.mp3"
    ((counter++))
    echo "Processing file $counter of $total_files: $file"
    if ! ffmpeg -i "$file" -q:a 0 "$output"; then
        echo -e "\e[31mFailed to convert: $file\e[0m"
    else
        echo "Converted: $file to $output"
    fi
done

