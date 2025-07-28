#!/bin/bash

show_menu() {
    echo "フォルダ一括動画変換ツール"
    echo "========================"
    echo "1) 動画圧縮 (H.264, CRF 28)"
    echo "2) GIF変換 (800px幅, 10fps)"
    echo "3) 終了"
    echo ""
}

compress_video() {
    local input_file="$1"
    local output_dir="$2"
    local filename=$(basename "$input_file")
    local extension="${filename##*.}"
    local name="${filename%.*}"
    local output_file="${output_dir}/${name}_compressed.${extension}"
    
    echo "動画を圧縮中: $filename -> ${name}_compressed.${extension}"
    ffmpeg -i "$input_file" -vcodec libx264 -crf 28 "$output_file" -y
    
    if [ $? -eq 0 ]; then
        echo "✓ 圧縮完了: ${name}_compressed.${extension}"
    else
        echo "✗ エラー: 圧縮に失敗しました - $filename"
    fi
}

convert_to_gif() {
    local input_file="$1"
    local output_dir="$2"
    local filename=$(basename "$input_file")
    local name="${filename%.*}"
    local output_file="${output_dir}/${name}.gif"
    
    echo "動画をGIFに変換中: $filename -> ${name}.gif"
    ffmpeg -i "$input_file" -vf scale=800:-1 -r 10 "$output_file" -y
    
    if [ $? -eq 0 ]; then
        echo "✓ 変換完了: ${name}.gif"
    else
        echo "✗ エラー: 変換に失敗しました - $filename"
    fi
}

process_folder() {
    local input_dir="$1"
    local output_dir="$2"
    local conversion_type="$3"
    
    # 出力ディレクトリが存在しない場合は作成
    if [ ! -d "$output_dir" ]; then
        mkdir -p "$output_dir"
        echo "出力ディレクトリを作成しました: $output_dir"
    fi
    
    # 対応する動画ファイル拡張子
    local video_extensions="mp4 mov avi mkv flv webm"
    local file_count=0
    local processed_count=0
    
    # ファイル数をカウント
    for ext in $video_extensions; do
        for file in "$input_dir"/*.$ext "$input_dir"/*.$( echo $ext | tr '[:lower:]' '[:upper:]'); do
            if [ -f "$file" ]; then
                ((file_count++))
            fi
        done
    done
    
    if [ $file_count -eq 0 ]; then
        echo "エラー: 対応する動画ファイルが見つかりませんでした"
        echo "対応形式: $video_extensions"
        return 1
    fi
    
    echo "見つかった動画ファイル: $file_count 個"
    echo "処理を開始します..."
    echo ""
    
    # 各動画ファイルを処理
    for ext in $video_extensions; do
        for file in "$input_dir"/*.$ext "$input_dir"/*.$( echo $ext | tr '[:lower:]' '[:upper:]'); do
            if [ -f "$file" ]; then
                ((processed_count++))
                echo "[$processed_count/$file_count]"
                
                if [ "$conversion_type" = "1" ]; then
                    compress_video "$file" "$output_dir"
                elif [ "$conversion_type" = "2" ]; then
                    convert_to_gif "$file" "$output_dir"
                fi
                echo ""
            fi
        done
    done
    
    echo "処理完了: $processed_count 個のファイルを処理しました"
}

# メイン処理
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
input_dir="$SCRIPT_DIR/input"
output_dir="$SCRIPT_DIR/output"

# 入力フォルダの確認
if [ ! -d "$input_dir" ]; then
    echo "エラー: 入力フォルダが見つかりません: $input_dir"
    echo "プロジェクトディレクトリにinputフォルダを作成してください"
    exit 1
fi

# 出力フォルダが存在しない場合は作成
if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
    echo "出力フォルダを作成しました: $output_dir"
fi

echo "入力フォルダ: $input_dir"
echo "出力フォルダ: $output_dir"
echo ""

while true; do
    show_menu
    read -p "選択してください (1-3): " choice
    
    case $choice in
        1)
            process_folder "$input_dir" "$output_dir" "1"
            break
            ;;
        2)
            process_folder "$input_dir" "$output_dir" "2"
            break
            ;;
        3)
            echo "終了します"
            exit 0
            ;;
        *)
            echo "無効な選択です"
            echo ""
            ;;
    esac
done
