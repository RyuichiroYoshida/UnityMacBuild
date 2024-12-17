# 環境変数の定義
UNITY_VERSION=2022.3.48f1
UNITY_EDITOR_PATH=/Applications/Unity/Hub/Editor/
PROJECT_PATH=/Users/vantan/Desktop/TeamA
EXPORT_PATH="/Users/vantan/Library/CloudStorage/GoogleDrive-vtnstorage.2023@gmail.com/その他のパソコン/マイ コンピュータ/Artifacts/Team2024/TeamA"
LOG_FILE_PATH=$PROJECT_PATH/log/TeamA.log
GAS_URL="https://script.google.com/macros/s/AKfycbz8goqh4NBZpD6v-mp4WCSoEZlPHuhOC2Yz5gq884ykcD0eP7lfBhVapedfLMUhzzAqjw/exec?folder=U2FsdGVkX1+KQa/6Ok6Ncn7IiRh8n3070sf4I/Y/D35d3Bv+3/xHbCHB23MXzuV8Dx+U+nV2LwcoW0CbBaH+xw==&team=A"

# 出力フォルダを処理のたびに削除する
if [ -e "$PROJECT_PATH/Build" ]; then
    rm -rf "$PROJECT_PATH/Build"
fi

# プロジェクト更新
cd $PROJECT_PATH
git pull https://github.com/VGA-Team2024/TeamA.git

if [ $? -eq 1 ]; then
    echo "プロジェクトの更新に失敗しました"
    exit 1
fi

# Unityビルドコマンドを実行する
"$UNITY_EDITOR_PATH$UNITY_VERSION/Unity.app/Contents/MacOS/Unity" -batchmode -quit -team "TeamA2024" -projectPath "$PROJECT_PATH" -executeMethod "BuildCommand.Build" -logfile "$LOG_FILE_PATH" -platform "Mac" -devmode true -outputPath "$PROJECT_PATH/Build"
if [ $? -eq 1 ]; then
    cat "./log/TeamA.log"
    exit 1
fi

# プロジェクトフォルダに移動
cd "$PROJECT_PATH"

# ビルドファイルを圧縮
zip -r MacTeamA.zip Build/

if [ $? -eq 1 ]; then
    exit 1
fi

# Google Driveへ移動
mv "$PROJECT_PATH/MacTeamA.zip" "$EXPORT_PATH"

curl -f "$GAS_URL"