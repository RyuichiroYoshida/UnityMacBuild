# 環境変数を.envファイルから読み込む
source ./e.env

# 出力フォルダを処理のたびに削除する
if [ -e "$PROJECT_PATH/Build" ]; then
    rm -rf "$PROJECT_PATH/Build"
fi

# プロジェクト更新
cd $PROJECT_PATH
git pull https://github.com/VGA-Team2024/TeamE.git

if [ $? -eq 1 ]; then
    echo "プロジェクトの更新に失敗しました"
    exit 1
fi

# Unityビルドコマンドを実行する
"$UNITY_EDITOR_PATH$UNITY_VERSION/Unity.app/Contents/MacOS/Unity" -batchmode -quit -team "TeamE2024" -projectPath "$PROJECT_PATH" -executeMethod "BuildCommand.Build" -logfile "$LOG_FILE_PATH" -platform "Mac" -devmode true -outputPath "$PROJECT_PATH/Build"
if [ $? -eq 1 ]; then
    cat "./log/TeamE.log"
    exit 1
fi

# プロジェクトフォルダに移動
cd "$PROJECT_PATH"

# ビルドファイルを圧縮
zip -r MacTeamE.zip Build/

if [ $? -eq 1 ]; then
    exit 1
fi

# Google Driveへ移動
mv "$PROJECT_PATH/MacTeamE.zip" "$EXPORT_PATH"

curl -f "$GAS_URL"