import os
from PIL import Image
from pathlib import Path

# Use this script to find corrupted images
root_dir = Path('/gpfs/scratch/acad/lysmed/navi_lstm/data/videos')
log_file_path = 'logfile.log'  

last_checked_folder = None

with open(log_file_path, 'a') as log_file:
    log_file.write("Starting image verification process.\n")
    log_file.flush()  
    
    for png_path in root_dir.rglob('*.png'):
        current_folder = png_path.parent
        if current_folder != last_checked_folder:
            log_file.write(f"Checking folder: {current_folder}\n")
            log_file.flush()  
            last_checked_folder = current_folder

        if not os.path.isfile(png_path):  
            log_file.write(f"Found a link or anomaly that is not a regular file: {png_path}\n")
            log_file.flush()
            continue  

        try:
            with Image.open(png_path) as img:
                img.verify()  
        except (OSError, Exception) as e:
            error_message = f"Corrupted file: {png_path} with error: {e}\n"
            log_file.write(error_message)
            log_file.flush()  # Flush apr  s avoir   crit une erreur.

    log_file.write("Image verification process completed.\n")
    log_file.flush() 
