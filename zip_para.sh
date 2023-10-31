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
mkdir -p "$DEST_DIR"

export SOURCE_DIR DEST_DIR

# Use GNU Parallel to compress folders
# Use GNU Parallel to compress folders
parallel -j 32 'bash -c "
  folder={}
  folder_name=\${folder##*/}
  zip_name=\$DEST_DIR/\${folder_name}.zip
  cd \$SOURCE_DIR && zip -q -r \${zip_name} \${folder_name}
  if [ -f \"\${zip_name}\" ]; then
    rm -r \${folder}
  fi
"' ::: "$SOURCE_DIR"/*


