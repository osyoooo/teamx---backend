from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.routers import quest, study  # ← add study

app = FastAPI(title="TeamX API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(quest.router, prefix=settings.API_PREFIX)
app.include_router(study.router, prefix=settings.API_PREFIX)  # ← register study router

@app.get("/")
def root():
    return {"message": "TeamX API"}

@app.get("/health")
def health():
    return {"status": "healthy"}
