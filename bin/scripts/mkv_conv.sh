#!/bin/sh

LOG_FILE='out/log.txt'
FILE_OUTPUT='out/'

for f in *.mkv; 
do
	#extract subtitles
	ffmpeg -i "$f" "$FILE_OUTPUT""${f%.mkv}.srt" 1>> "$LOG_FILE" 2>&1

	#convert mkv to mp4 and convert audio to aac 
	ffmpeg -i "$f" -c:v copy -c:a aac "$FILE_OUTPUT""${f%.mkv}.mp4" 1>> "$LOG_FILE" 2>&1
done

if [ "$?" -ne 0 ]; then
	echo "Script is unsuccessful" 1>> "$LOG_FILE" 2>&1
fi

echo "Script is successful" 1>> "$LOG_FILE" 2>&1
