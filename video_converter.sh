#!/bin/bash

show_menu() {
  echo ""
  echo "1) Video Compression"
  echo "2) GIF Conversion"
  echo "3) Exit"
  echo ""
}

compress_video() {
  local input_file="$1"
  local output_dir="$2"
  local filename=$(basename "$input_file")
  local extension="${filename##*.}"
  local name="${filename%.*}"
  local output_file="${output_dir}/${name}_compressed.${extension}"

  echo "Compressing: $filename"
  ffmpeg -i "$input_file" -vcodec libx264 -crf 28 "$output_file" -y

  if [ $? -eq 0 ]; then
    echo "[SUCCESS] Compression completed: ${name}_compressed.${extension}"
  else
    echo ""
    echo "[ERROR] Compression failed: $filename"
  fi
}

convert_to_gif() {
  local input_file="$1"
  local output_dir="$2"
  local filename=$(basename "$input_file")
  local name="${filename%.*}"
  local output_file="${output_dir}/${name}.gif"

  echo "Converting to GIF: $filename"
  ffmpeg -i "$input_file" -vf "fps=15,scale=640:-1:flags=lanczos,palettegen=stats_mode=diff" -y /tmp/palette.png && ffmpeg -i "$input_file" -i /tmp/palette.png -filter_complex "fps=15,scale=640:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=5" "$output_file" -y

  if [ $? -eq 0 ]; then
    echo "[SUCCESS] GIF conversion completed: ${name}.gif"
  else
    echo ""
    echo "[ERROR] GIF conversion failed: $filename"
  fi
}

process_folder() {
  local input_dir="$1"
  local output_dir="$2"
  local conversion_type="$3"

  # Create output directory if it doesn't exist
  if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
    echo "[INFO] Created output directory: $output_dir"
  fi

  # 動画ファイルを一括取得
  shopt -s nullglob nocaseglob
  local video_files=()

  # 各拡張子で個別にファイルを検索
  for ext in mp4 mov avi mkv flv webm; do
    for file in "$input_dir"/*.$ext; do
      [ -f "$file" ] && video_files+=("$file")
    done
  done

  shopt -u nullglob nocaseglob

  local file_count=${#video_files[@]}

    if [ $file_count -eq 0 ]; then
      echo ""
      echo "[ERROR] No supported video files found"
      echo "Supported formats: mp4, mov, avi, mkv, flv, webm"
      return 1
    fi

    echo "Found $file_count video files"

    # Process each video file
    for i in "${!video_files[@]}"; do
      local file="${video_files[$i]}"
      echo "[$((i+1))/$file_count]"
      if [ "$conversion_type" = "1" ]; then
        compress_video "$file" "$output_dir"
      elif [ "$conversion_type" = "2" ]; then
        convert_to_gif "$file" "$output_dir"
      fi
    done

    echo "Completed: $file_count files processed"
    return 0
  }

# メイン処理
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
input_dir="$SCRIPT_DIR/input"
output_dir="$SCRIPT_DIR/output"

# Check input folder
if [ ! -d "$input_dir" ]; then
  echo ""
  echo "[ERROR] Input folder not found: $input_dir"
  echo "Please create an 'input' folder in the project directory"
  exit 1
fi

# Create output folder if it doesn't exist
if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
  echo "[INFO] Created output folder: $output_dir"
fi


while true; do
  show_menu
  read -p "Please select an option (1-3): " choice

  case $choice in
    1)
      process_folder "$input_dir" "$output_dir" "1"
      ;;
    2)
      process_folder "$input_dir" "$output_dir" "2"
      ;;
    3)
      echo "Goodbye!"
      exit 0
      ;;
    *)
      # Invalid input is ignored, menu will redisplay
      ;;
  esac
done
