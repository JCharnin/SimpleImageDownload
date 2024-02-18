#!/bin/bash

# Function to check if a URL contains a blacklisted keyword
skip_url() {
    local url="$1"
    local skip_list=("facebook" "instagram" "linkedin" "twitter" "foursquare")
    for keyword in "${skip_list[@]}"; do
        if echo "$url" | grep -qi "$keyword"; then
            return 0
        fi
    done
    return 1
}

# Function to download and rename images
download_images() {
    local input_file="$1"
    local title=$(head -n 1 "$input_file" | tr -d '\r\n' | tr -d '\n\r')
    local timestamp=$(date +"%m-%d-%Y")
    local count=1
    local folder_name="${title// /_}"  # Replace spaces with underscores for folder name

    mkdir -p "$folder_name"  # Create folder if it doesn't exist

    while IFS= read -r url; do
        if skip_url "$url"; then
            echo "Skipping $url"
            continue
        fi
        extension="${url##*.}"
        if [[ $extension =~ ^(jpg|jpeg|png|gif|svg|tiff|bmp|webp)$ ]]; then
            filename=$(basename "$url")
            filename="${title}-${filename%%.*}-${timestamp}-$(printf "%02d" "$count").$extension"
            echo "Downloading $url as $folder_name/$filename"
            curl -s "$url" -o "$folder_name/$filename"
            ((count++))
        fi
    done < <(tail -n +2 "$input_file")
}

# Main script
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Input file not found: $1"
    exit 1
fi

download_images "$1"