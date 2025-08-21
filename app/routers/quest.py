from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas import QuestListResponse, QuestDetail, QuestApplyRequest, QuestApplyResponse
from app.crud import get_quest_list, get_quest_detail, apply_quest

router = APIRouter(prefix="/quests", tags=["quests"])

# 仮のユーザーID（実際は認証から取得）
def get_current_user_id():
    return 1

@router.get("/available", response_model=QuestListResponse)
def get_available_quests(db: Session = Depends(get_db)):
    """応募可能なクエスト一覧"""
    user_id = get_current_user_id()
    quests = get_quest_list(db, user_id, "available")
    return {
        "status": "available",
        "quests": quests,
        "total_count": len(quests)
    }

@router.get("/in-progress", response_model=QuestListResponse)
def get_in_progress_quests(db: Session = Depends(get_db)):
    """進行中のクエスト一覧"""
    user_id = get_current_user_id()
    quests = get_quest_list(db, user_id, "in_progress")
    return {
        "status": "in_progress",
        "quests": quests,
        "total_count": len(quests)
    }

@router.get("/{quest_id}", response_model=QuestDetail)
def get_quest(quest_id: int, db: Session = Depends(get_db)):
    """クエスト詳細"""
    quest = get_quest_detail(db, quest_id)
    if not quest:
        raise HTTPException(status_code=404, detail="クエストが見つかりません")
    return quest

@router.post("/apply", response_model=QuestApplyResponse)
def apply_to_quest(request: QuestApplyRequest, db: Session = Depends(get_db)):
    """クエストに応募"""
    user_id = get_current_user_id()
    success, message = apply_quest(db, user_id, request.quest_id)
    if not success:
        raise HTTPException(status_code=400, detail=message)
    return {"success": success, "message": message}