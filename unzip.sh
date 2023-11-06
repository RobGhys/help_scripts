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

# Create destination directory
mkdir -p "$DEST_DIR"

i=0
# Loop in zip files
for zip_file in "$SOURCE_DIR"/*.zip; do
  ((i++))
  echo "[START] Iteration $i"
  echo "zip file: $zip_file"
  if [ -f "$zip_file" ]; then # -f to check if it is a file
    # Get name of the zip file without extension
    base_name="$(basename "$zip_file" .zip)" #extract base name without extension
    echo "Unzipping file: $base_name"
    
    # Define folder name where to unzip
    folder_name="$DEST_DIR/$base_name"
    echo "Folder will be created: $folder_name"

    # Start timer
    start_time=$(date +%s)

    # Unzip file into the destination directory
    unzip -q "$zip_file" -d "$folder_name"
    
    # End timer and compute duration
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    echo "[TIME] Time taken for unzipping: $duration seconds"
    
    # Check if the folder was created successfully
    if [ -d "$folder_name" ]; then
      echo "Folder created successfully, removing zip file."
      # Remove the zip file after unzipping
      rm "$zip_file"
    else
      echo "Folder was not created, skipping zip file removal."
    fi
  else
    echo "Skipping: $zip_file is not a file"
  fi
  echo "[END] $zip_file done"
  echo
done

echo "Finish unzip"
