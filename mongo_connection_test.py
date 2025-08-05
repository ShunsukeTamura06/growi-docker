#!/usr/bin/env python3
"""MongoDB接続テストスクリプト"""

from pymongo import MongoClient
import sys
import os

def test_connection(connection_string):
    """MongoDB接続をテストする"""
    try:
        # クライアント作成
        client = MongoClient(connection_string, serverSelectionTimeoutMS=5000)
        
        # 接続テスト
        client.admin.command('ping')
        print("✅ MongoDB接続成功")
        
        # データベース一覧取得
        databases = client.list_database_names()
        print(f"📁 利用可能なデータベース: {databases}")
        
        # サーバー情報取得
        server_info = client.server_info()
        print(f"🔧 MongoDB Version: {server_info.get('version', 'Unknown')}")
        
        return True
        
    except Exception as e:
        print(f"❌ 接続エラー: {e}")
        return False
    finally:
        try:
            client.close()
        except:
            pass

def main():
    """メイン関数"""
    if len(sys.argv) != 2:
        print("使用方法: python mongo_connection_test.py '<connection_string>'")
        print("例: python mongo_connection_test.py 'mongodb://username:password@endpoint:27017/?tls=true&tlsCAFile=rds-combined-ca-bundle.pem'")
        sys.exit(1)
    
    connection_string = sys.argv[1]
    print(f"🔗 接続先: {connection_string.split('@')[1] if '@' in connection_string else connection_string}")
    print("⏳ 接続テスト中...")
    
    success = test_connection(connection_string)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
