# TeamX Backend API

## セットアップ
1. `pip install -r requirements.txt`
2. `.env`ファイルを作成し、データベース情報を設定
3. `uvicorn app.main:app --reload`

## エンドポイント
- GET /api/v1/quests/available - 応募可能なクエスト一覧
- GET /api/v1/quests/in-progress - 進行中のクエスト一覧
- GET /api/v1/quests/{quest_id} - クエスト詳細
- POST /api/v1/quests/apply - クエスト応募

## 今後の拡張
- `routers/study.py` - 学習機能
- `routers/yell.py` - Yell機能
- `routers/profile.py` - プロフィール機能