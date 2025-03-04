#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y ffmpeg
output_file="filelist.txt"
> $output_file
for file in $(find /mnt/photo -type f -name '*.jpg'); do
  echo "file '$file'" >> $output_file
  echo "duration 5" >> $output_file
done
ffmpeg -f concat -safe 0 -i $output_file -vsync vfr -pix_fmt yuv420p diaporama.mkv
echo "Le diaporama a été généré sous le nom de diaporama.mkv"