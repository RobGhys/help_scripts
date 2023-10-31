# ------------------------- work -------------------------
echo "Start zip"
# Source 
SOURCE_DIR="/home/rob/Documents/tmp/videos"

# Destination directory
DEST_DIR="/home/rob/Documents/tmp/videos_zip"

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


