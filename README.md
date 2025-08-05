# GROWI Docker Setup

GROWIサーバーをDockerで構築するための設定ファイルです。

## 機能
- GROWI本体
- MongoDB（データベース）
- Redis（キャッシュ）
- Elasticsearch（全文検索）

## 使用方法

```bash
docker compose up -d
```

ブラウザで `http://localhost:8080` にアクセスしてください。

## MongoDB接続確認

EC2からMongoDB（DocumentDB）への接続を確認する場合：

### 1. 自動テストスクリプト使用

```bash
# 実行権限付与
chmod +x check_mongo_connection.sh

# 接続テスト実行
./check_mongo_connection.sh "mongodb://username:password@endpoint:27017/?tls=true&tlsCAFile=rds-combined-ca-bundle.pem"
```

### 2. Pythonスクリプト単体使用

```bash
# 必要なライブラリインストール
pip install pymongo

# 接続テスト実行
python3 mongo_connection_test.py "mongodb://username:password@endpoint:27017/?tls=true&tlsCAFile=rds-combined-ca-bundle.pem"
```

### 3. TLS証明書のダウンロード

```bash
wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -O rds-combined-ca-bundle.pem
```

### トラブルシューティング
- セキュリティグループで27017ポートが許可されているか確認
- 認証情報（ユーザー名・パスワード）が正確か確認
- エンドポイントが正しいか確認

## 全文検索の設定

初回起動後、以下の手順で全文検索を有効化してください：

1. 管理者でログイン
2. 管理画面 → 全文検索管理（`/admin/search`）にアクセス
3. 「インデックスのリビルド」ボタンをクリック

これでGROWI内の全文検索が利用可能になります。
