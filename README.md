# Image Downloader Script (Mac Only)

This script is designed for macOS systems and utilizes osascript for GUI interactions. It allows users to download and rename images from either a text file containing image URLs or directly from a webpage URL.

## Requirements

This script is intended for macOS only.
Users need to grant permission for the script to access the file browser when prompted.

## Usage

Ensure the script is executable by running:

1. Opening a terminal (bash)
2. Copy code and execute this code:
    *chmod +x download_images.sh*
3. Copy code and execute this code:
    *./download_images.sh*

## Usage - Menu Options

**Load images from a text file:** Prompts the user to select a text file containing image URLs. It then asks for a folder name to save the downloaded images.

**Provide a single page URL:** Prompts the user to enter a webpage URL. It also requests a folder name to save the downloaded images.

**Exit:** Terminates the script.

## File Naming Convention

Images are saved in a folder named after the title provided in the text file. The file names are constructed with the format: [original_filename]-[timestamp]-[image_number].[extension].

## Skipping URLs

The script skips URLs containing certain blacklisted keywords, such as "facebook", "instagram", and "linkedin". These URLs are not downloaded.

## Spellcheck

This script does not include a spellcheck feature.

## Maintaining Skip List

To maintain the list of skipped keywords, edit the skip_list array in the script.

## License

This script is provided under the MIT License. See LICENSE file for details.