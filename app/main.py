from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.routers import quest

app = FastAPI(title="TeamX API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ルーターの登録
app.include_router(quest.router, prefix=settings.API_PREFIX)

@app.get("/")
def root():
    return {"message": "TeamX API"}

@app.get("/health")
def health():
    return {"status": "healthy"}