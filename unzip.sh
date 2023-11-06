#!/bin/bash
#
#SBATCH --job-name=unzip_images
#SBATCH --time=2:00:00 # hh:mm:ss
#
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=4096
#
#SBATCH --mail-user=robin.ghyselinck@unamur.be
#SBATCH --mail-type=ALL
#
#SBATCH --account=lysmed

# ------------------------- work -------------------------
echo "Start unzip"
# Destination directory changed to source directory for unzip operation
SOURCE_DIR="/gpfs/scratch/acad/lysmed/data/videos_zip"

# Source directory changed to destination directory for unzip operation
DEST_DIR="/gpfs/scratch/acad/lysmed/navi_lstm/data/videos"

# Create destination directory if it does not exist
mkdir -p "$DEST_DIR"

i=0
# Loop over .zip files in the source directory
for zip_file in "$SOURCE_DIR"/*.zip; do
  ((i++))
  echo "[START] Iteration $i"
  if [ -f "$zip_file" ]; then # Check if it's a file
    base_name="$(basename "$zip_file" .zip)" # Get the base name without the .zip extension
    temp_unzip_dir="$DEST_DIR/temp_$base_name" # Temporary directory for unzipping
    final_unzip_dir="$DEST_DIR/$base_name" # Final directory path

    echo "Unzipping $zip_file to temporary directory $temp_unzip_dir"
    mkdir -p "$temp_unzip_dir" # Create temporary directory
    unzip -q "$zip_file" -d "$temp_unzip_dir" # Unzip to temporary directory

    # Move content to the final directory
    mv "$temp_unzip_dir"/*/* "$final_unzip_dir" # Adjust this depending on the exact internal ZIP structure

    # Check if directory exists and is not empty before deleting temporary directory
    if [ -d "$final_unzip_dir" ] && [ "$(ls -A "$final_unzip_dir")" ]; then
      echo "Unzip successful, cleaning up."
      rm -r "$temp_unzip_dir" # Remove temporary directory
      rm "$zip_file" # Remove the original zip file after successful extraction
    else
      echo "Unzip may have failed - temp directory is missing or empty."
    fi
  else
    echo "Skipping: $zip_file is not a valid file."
  fi
  echo "[END] Iteration $i"
done

echo "Finish unzip"
