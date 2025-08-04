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

## 全文検索の設定

初回起動後、以下の手順で全文検索を有効化してください：

1. 管理者でログイン
2. 管理画面 → 全文検索管理（`/admin/search`）にアクセス
3. 「インデックスのリビルド」ボタンをクリック

これでGROWI内の全文検索が利用可能になります。