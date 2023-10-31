echo "Start zip"
# Source 
SOURCE_DIR="/home/rob/Documents/tmp/videos"

# Destination directory
DEST_DIR="/home/rob/Documents/tmp/videos_zip"

# Create destination directory
mkdir -p "$DEST_DIR"

i=0
# Loop in folders
for folder in "$SOURCE_DIR"/*; do
  ((i++))
  echo "[START] Iteration $i"
  echo "folder: $folder"
  if [ -d "$folder" ]; then # -d to check if specified path (folder) is a directory
    # Get name of the folder in path
    folder_name="${folder##*/}" #inside $(...) is considered as shell command;; manipulate string to get folder name
    echo "Zipping folder: $folder_name"
    
    # Define zip name
    zip_name="$DEST_DIR/${folder_name}.zip"
    echo "Zip file will be named: $zip_name"

    # Start timer
    start_time=$(date +%s)

    # Compress folder in current directory
    (
      cd "$SOURCE_DIR"
      zip -q -r "$zip_name" "$folder_name"
    )
    
    # End timer and compute duration
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    echo "[TIME] Time taken for zipping: $duration seconds"
    
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
  # Print empty line
  echo "[END] $folder done"
  echo
done

echo "Finish zip"