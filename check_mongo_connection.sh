#!/bin/bash
# MongoDB接続確認スクリプト

set -e

# カラーコード
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}MongoDB接続確認ツール${NC}"
echo "============================="

# 引数チェック
if [ $# -ne 1 ]; then
    echo -e "${RED}使用方法: $0 '<connection_string>'${NC}"
    echo "例: $0 'mongodb://username:password@endpoint:27017/?tls=true&tlsCAFile=rds-combined-ca-bundle.pem'"
    exit 1
fi

CONNECTION_STRING="$1"

# ネットワーク接続確認
echo -e "${YELLOW}1. ネットワーク接続確認${NC}"
ENDPOINT=$(echo "$CONNECTION_STRING" | sed -n 's/.*@\([^:]*\):.*/\1/p')
PORT=$(echo "$CONNECTION_STRING" | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')

if [ -z "$ENDPOINT" ] || [ -z "$PORT" ]; then
    echo -e "${RED}❌ 接続文字列からエンドポイントまたはポートを抽出できませんでした${NC}"
    exit 1
fi

echo "エンドポイント: $ENDPOINT"
echo "ポート: $PORT"

# ポート接続確認
if timeout 5 bash -c "</dev/tcp/$ENDPOINT/$PORT" 2>/dev/null; then
    echo -e "${GREEN}✅ ネットワーク接続OK${NC}"
else
    echo -e "${RED}❌ ネットワーク接続失敗${NC}"
    exit 1
fi

# TLS証明書ファイル確認
if [[ "$CONNECTION_STRING" == *"tlsCAFile="* ]]; then
    echo -e "${YELLOW}2. TLS証明書ファイル確認${NC}"
    CERT_FILE=$(echo "$CONNECTION_STRING" | sed -n 's/.*tlsCAFile=\([^&]*\).*/\1/p')
    if [ -f "$CERT_FILE" ]; then
        echo -e "${GREEN}✅ 証明書ファイル存在: $CERT_FILE${NC}"
    else
        echo -e "${RED}❌ 証明書ファイルが見つかりません: $CERT_FILE${NC}"
        echo "RDS証明書をダウンロードしてください:"
        echo "wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -O rds-combined-ca-bundle.pem"
        exit 1
    fi
fi

# Python接続テスト
echo -e "${YELLOW}3. MongoDB接続テスト${NC}"
if command -v python3 &> /dev/null; then
    if python3 -c "import pymongo" 2>/dev/null; then
        python3 mongo_connection_test.py "$CONNECTION_STRING"
    else
        echo -e "${RED}❌ pymongoがインストールされていません${NC}"
        echo "pip install pymongo でインストールしてください"
        exit 1
    fi
else
    echo -e "${RED}❌ Python3がインストールされていません${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 すべてのテストが完了しました${NC}"
