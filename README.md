# Video Converter

フォルダ一括動画変換ツール - 指定フォルダ内の動画ファイルを一括で圧縮またはGIF変換

## 機能

- **動画圧縮**: H.264エンコード、CRF 28で高品質圧縮
- **GIF変換**: 800px幅、10fpsでGIFアニメーション作成
- **一括処理**: フォルダ内の全動画ファイルを自動検出・変換

## サポート形式

- **入力形式**: MP4, MOV, AVI, MKV, FLV, WebM (大文字小文字対応)
- **出力形式**: 
  - 圧縮: 元ファイルと同じ形式
  - GIF変換: GIF形式

## プロジェクト構造

```
video-converter/
├── README.md
├── video_converter.sh    # メインスクリプト
├── input/               # 変換したい動画ファイルを配置
└── output/              # 変換後のファイルが保存される
```

## 使用方法

### 1. セットアップ

```bash
# プロジェクトディレクトリに移動
cd video-converter

# スクリプトに実行権限を付与
chmod +x video_converter.sh
```

### 2. 動画ファイルの配置

変換したい動画ファイルを `input/` フォルダに配置してください。

```bash
cp /path/to/your/videos/* input/
```

### 3. 変換実行

```bash
./video_converter.sh
```

メニューから変換タイプを選択：
- **1**: 動画圧縮 (H.264, CRF 28)
- **2**: GIF変換 (800px幅, 10fps)
- **3**: 終了

### 4. 結果確認

変換されたファイルは `output/` フォルダに保存されます。

## 変換例

### 動画圧縮
- `sample.mp4` → `sample_compressed.mp4`
- ファイルサイズ削減、品質維持

### GIF変換
- `sample.mp4` → `sample.gif`
- Web用アニメーションファイル

## 必要な環境

- **FFmpeg**: 動画・音声変換ライブラリ
- **Bash**: Unix系シェル環境

### FFmpegのインストール

#### macOS (Homebrew)
```bash
brew install ffmpeg
```

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install ffmpeg
```

#### Windows (Chocolatey)
```bash
choco install ffmpeg
```

## 注意事項

- 大きなファイルや多数のファイルの変換には時間がかかります
- 既存の出力ファイルは自動的に上書きされます
- `input/` フォルダが存在しない場合はエラーになります

## ログとエラー

- 処理進捗: `[1/5]` 形式で表示
- 成功: ✓ マーク付きで表示  
- エラー: ✗ マーク付きでエラー内容を表示

## ライセンス

MIT License