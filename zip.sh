#!/bin/bash
#
#SBATCH --job-name=zip_images
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
echo "Start zip"
# Source 
SOURCE_DIR="/gpfs/scratch/acad/lysmed/navi_lstm/data/videos"

# Destination directory
DEST_DIR="/gpfs/scratch/acad/lysmed/data/videos_zip"

# Create destination directory
mkdir -p $DEST_DIR

# Loop in folders
for folder in $SOURCE_DIR/*; do
  if [ -d "$folder" ]; then
    # Get name of the folder in path
    folder_name=$(basename $folder)
    
    # Compress file
    zip -r $DEST_DIR/${folder_name}.zip $folder
