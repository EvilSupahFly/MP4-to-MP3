#!/bin/bash
#
# I know many distros have shortened apt-get to just apt, but I'm keeping apt-get for backwards-compatibility with older distros
#
# Check for FFMPEG installation
check_ffmpeg() {
    if ! command -v ffmpeg &> /dev/null; then
        echo "FFMPEG is not installed. Installing now..."
        sudo apt-get update && sudo apt-get install -y ffmpeg
    fi
}

# Convert files with progress indication
convert_with_progress() {
    local dir=${1:-.}
    local total_files=$(find "$dir" -type f \( -iname "*.mp4" -o -iname "*.m4a" \) | wc -l)
    local processed_files=0

    find "$dir" -type f \( -iname "*.mp4" -o -iname "*.m4a" \) | while read -r file; do
        output="${file%.*}.mp3"
        if ffmpeg -i "$file" -q:a 0 "$output"; then
            processed_files=$((processed_files + 1))
            echo "Converted: $file to $output ($processed_files/$total_files)"
        else
            echo -e "\e[31mFailed to convert: $file\e[0m"
        fi
    done
}

# Execute the script
check_ffmpeg
convert_with_progress "$1"
