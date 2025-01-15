#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y ffmpeg
output_file="filelist.txt"
> $output_file
for file in $(find /mnt/photo/. -type f -name '*.jpg'); do
  echo "file '$file'" >> $output_file
  echo "duration 10" >> $output_file
done
ffmpeg -f concat -safe 0 -i $output_file -vsync vfr -pix_fmt yuv420p diaporama.mp4
echo "Diaporama généré sous le nom diaporama.mp4."
#ffmpeg -f concat -safe 0 -i filelist.txt -vsync vfr -pix_fmt yuv420p diaporama.mp4










root@ubuntu:/mnt/photo# ffmpeg -f concat -safe 0 -i filelist.txt -vsync vfr -pix_fmt yuv420p diaporama.mp4
ffmpeg version 6.1.1-3ubuntu5 Copyright (c) 2000-2023 the FFmpeg developers
  built with gcc 13 (Ubuntu 13.2.0-23ubuntu3)
  configuration: --prefix=/usr --extra-version=3ubuntu5 --toolchain=hardened --libdir=/usr/lib/x86_64-linux-gnu --incdir=/usr/include/x86_64-linux-gnu --arch=amd64 --enable-gpl --disable-stripping --disable-omx --enable-gnutls --enable-libaom --enable-libass --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libdav1d --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libglslang --enable-libgme --enable-libgsm --enable-libharfbuzz --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzimg --enable-openal --enable-opencl --enable-opengl --disable-sndio --enable-libvpl --disable-libmfx --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-chromaprint --enable-frei0r --enable-ladspa --enable-libbluray --enable-libjack --enable-libpulse --enable-librabbitmq --enable-librist --enable-libsrt --enable-libssh --enable-libsvtav1 --enable-libx264 --enable-libzmq --enable-libzvbi --enable-lv2 --enable-sdl2 --enable-libplacebo --enable-librav1e --enable-pocketsphinx --enable-librsvg --enable-libjxl --enable-shared
  libavutil      58. 29.100 / 58. 29.100
  libavcodec     60. 31.102 / 60. 31.102
  libavformat    60. 16.100 / 60. 16.100
  libavdevice    60.  3.100 / 60.  3.100
  libavfilter     9. 12.100 /  9. 12.100
  libswscale      7.  5.100 /  7.  5.100
  libswresample   4. 12.100 /  4. 12.100
  libpostproc    57.  3.100 / 57.  3.100
-vsync is deprecated. Use -fps_mode
[concat @ 0x648d3a55a380] Impossible to open './unnamed'
[in#0 @ 0x648d3a55a280] Error opening input: No such file or directory
Error opening input file filelist.txt.
Error opening input files: No such file or directory






                                                                                                                                                                                      #!/bin/bash
for file in $(find /mnt/photo -type f -name 'unnamed*'); do
        mv $file /home/bazar
done

for file in $(find /mnt/photo -type f -name 'unnamed*'); do
        echo "$file"
done





#!/bin/bash

# Trouver tous les fichiers 'unnamed*' et les déplacer vers /home/bazar
find /mnt/photo -type f -name 'unnamed*' | while IFS= read -r file; do
    mv "$file" /home/bazar
done

echo "Tous les fichiers 'unnamed*' ont été déplacés vers /home/bazar."