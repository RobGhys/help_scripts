echo "Start zip"
# Source 
SOURCE_DIR="/home/rob/Documents/tmp/videos"

# Destination directory
DEST_DIR="/home/rob/Documents/tmp/videos_zip"

# Create destination directory
mkdir -p "$DEST_DIR"

# Loop in folders
for folder in "$SOURCE_DIR"/*; do
  echo "Checking folder: $folder"
  if [ -d "$folder" ]; then # -d to check if specified path (folder) is a directory
    # Get name of the folder in path
    folder_name="${folder##*/}" #inside $(...) is considered as shell command;; manipulate string to get folder name
    echo "Zipping folder: $folder_name"
    
    # Define zip name
    zip_name="$DEST_DIR/${folder_name}.zip"
    echo "Zip file will be named: $zip_name"

    # Compress in current directory
    (
      cd "$SOURCE_DIR"
      zip -q -r "$zip_name" "$folder_name"
    )

    # Check if the zip file was created successfully
    if [ -f "$zip_name" ]; then
      echo "Zip file created successfully, removing folder."
      # Remove the folder after zipping
      rm -r "$folder"
    else
      echo "Zip file was not created, skipping folder removal."
    fi

  else
  echo "Skipping: $folder is not a directory"
  fi
done

echo "Finish zip"