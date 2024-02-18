#!/bin/bash

# Function to check if a URL contains a blacklisted keyword
skip_url() {
    local url="$1"
    local skip_list=("facebook" "instagram" "linkedin")
    for keyword in "${skip_list[@]}"; do
        if echo "$url" | grep -qi "$keyword"; then
            return 0
        fi
    done
    return 1
}

# Function to download and rename images from text file
download_images_from_text() {
    local input_file="$1"
    local folder_name="$2"
    local timestamp=$(date +"%m-%d-%Y")
    local count=1

    mkdir -p "$folder_name"  # Create folder if it doesn't exist

    while IFS= read -r url; do
        if skip_url "$url"; then
            echo "Skipping $url"
            continue
        fi
        extension="${url##*.}"
        if [[ $extension =~ ^(jpg|jpeg|png|gif|svg|tiff|bmp|webp)$ ]]; then
            filename=$(basename "$url")
            filename="${folder_name}/${filename%%.*}-${timestamp}-$(printf "%02d" "$count").$extension"
            echo "Downloading $url as $filename"
            curl -s "$url" -o "$filename"
            ((count++))
        fi
    done < "$input_file"
}

# Function to download and rename images from webpage URL
download_images_from_webpage() {
    local webpage_url="$1"
    local folder_name="$2"
    local timestamp=$(date +"%m-%d-%Y")
    local count=1

    mkdir -p "$folder_name"  # Create folder if it doesn't exist

    # Download webpage and extract image URLs
    img_urls=$(curl -s "$webpage_url" | grep -Eo '<img[^>]+src="[^"]+"' | sed -E 's/<img[^>]+src="([^"]+)"/\1/g')
    for img_url in $img_urls; do
        if skip_url "$img_url"; then
            echo "Skipping $img_url"
            continue
        fi
        extension="${img_url##*.}"
        if [[ $extension =~ ^(jpg|jpeg|png|gif|svg|tiff|bmp|webp)$ ]]; then
            filename=$(basename "$img_url")
            filename="${folder_name}/${filename%%.*}-${timestamp}-$(printf "%02d" "$count").$extension"
            echo "Downloading $img_url as $filename"
            curl -s "$img_url" -o "$filename"
            ((count++))
        fi
    done
}

# Function to prompt user to select a file via file dialog
select_file() {
    local file_path
    file_path=$(osascript -e 'tell application "Finder" to set filePath to POSIX path of (choose file)')
    echo "$file_path"
}

# Main menu
menu() {
    local choice
    while true; do
        choice=$(osascript -e 'choose from list {"Load images from a text file", "Provide a single page URL", "Exit"} with title "Image Downloader"')
        case $choice in
            "Load images from a text file")
                local input_file
                input_file=$(select_file)
                if [[ -n $input_file ]]; then
                    local folder_name
                    folder_name=$(osascript -e 'text returned of (display dialog "Enter folder name:" default answer "")')
                    if [[ -n $folder_name ]]; then
                        download_images_from_text "$input_file" "$folder_name"
                        osascript -e 'display alert "Images downloaded successfully!"'
                    else
                        osascript -e 'display alert "Folder name cannot be empty!"'
                    fi
                fi
                ;;
            "Provide a single page URL")
                local webpage_url
                webpage_url=$(osascript -e 'text returned of (display dialog "Enter webpage URL:" default answer "")')
                if [[ -n $webpage_url ]]; then
                    local folder_name
                    folder_name=$(osascript -e 'text returned of (display dialog "Enter folder name:" default answer "")')
                    if [[ -n $folder_name ]]; then
                        download_images_from_webpage "$webpage_url" "$folder_name"
                        osascript -e 'display alert "Images downloaded successfully!"'
                    else
                        osascript -e 'display alert "Folder name cannot be empty!"'
                    fi
                fi
                ;;
            "Exit")
                exit 0
                ;;
            *)
                ;;
        esac
    done
}

# Run the main menu
menu