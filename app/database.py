from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from app.config import settings

# エンジンの作成（開発環境用の設定）
engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,  # 接続の事前確認
    pool_size=5,         # 接続プールサイズ
    max_overflow=10      # 最大オーバーフロー
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()