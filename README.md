# Image Downloader Script

This bash script is designed to download images from a list of URLs provided in a text file. It allows you to specify a title at the top of the text file, which is used to create a folder for storing the downloaded images. Each image is renamed with a combination of the title, the original file name, and the current date.

## Usage

1. Create a text file containing a title on the first line followed by a list of image URLs.
2. Make sure each URL is on a separate line.
3. Run the script with the path to the text file as an argument.

Example in bash:

./download_images.sh image_urls.txt

## File Naming Convention

Images are saved in a folder named after the title provided in the text file. The file names are constructed as follows:

## Skipping URLs

The script skips URLs containing certain blacklisted keywords, such as "facebook", "instagram", and "linkedin". These URLs are not downloaded.

## Spellcheck

The script does not include a spellcheck feature.

## Maintaining Skip List

To maintain the list of skipped keywords, edit the `skip_list` array in the script.

## Requirements

- Bash shell
- curl command-line tool

## License

This script is provided under the MIT License. See LICENSE file for details.