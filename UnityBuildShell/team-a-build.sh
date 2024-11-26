# 環境変数の定義
UNITY_VERSION=2022.3.48f1
UNITY_EDITOR_PATH=/Applications/Unity/Hub/Editor/
PROJECT_PATH=/Users/vantan/Desktop/TeamA
EXPORT_PATH=/Users/vantan/Library/CloudStorage/GoogleDrive-vtnstorage.2023@gmail.com/その他のパソコン/マイ コンピュータ/Artifacts/Team2024
LOG_FILE_PATH=$PROJECT_PATH/log/TeamA.log
GAS_URL=https://script.google.com/macros/s/AKfycbwFE95eSPBTax07d3mrhXX1FKK8uWJnbdqLZM_8toC07dVhlV23yaAWeb8NCFeVa56Q/exec?folder=U2FsdGVkX1+KQa/6Ok6Ncn7IiRh8n3070sf4I/Y/D35d3Bv+3/xHbCHB23MXzuV8Dx+U+nV2LwcoW0CbBaH+xw==&team=A

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
"$UNITY_EDITOR_PATH$UNITY_VERSION\Editor\Unity.exe" -batchmode -quit -projectPath "$PROJECT_PATH" -executeMethod "BuildCommand.Build" -logfile "$LOG_FILE_PATH" -platform "Mac" -devmode true -outputPath "$PROJECT_PATH/Build"

if [ $? -eq 1 ]; then
    cat "./log/TeamA.log"
    exit 1
fi

# ビルドファイルの圧縮してGoogleDriveへ配置
zip -r "TeamA.zip" "$PROJECT_PATH/Build"

if [ $? -eq 1 ]; then
    exit 1
fi

mv "$PROJECT_PATH\TeamA.zip" "$EXPORT_PATH"

curl -f "$GAS_URL"

pause