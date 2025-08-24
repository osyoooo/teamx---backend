from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas import (
    QuestListResponse, QuestDetail, QuestApplyRequest, QuestApplyResponse,
    QuestListResponseV2
)
from app.crud import (
    get_quest_list, get_quest_detail, apply_quest, get_upcoming_quests,
    get_quest_list_v2, get_upcoming_quests_v2 as get_upcoming_quests_v2_crud
)
from app.models import User

router = APIRouter(prefix="/quests", tags=["quests"])

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

@router.get("/upcoming", response_model=QuestListResponse)
def get_upcoming_quests_endpoint(db: Session = Depends(get_db)):
    """まもなく解放されるクエスト一覧"""
    user_id = get_current_user_id()
    quests = get_upcoming_quests(db, user_id)
    return {
        "status": "upcoming",
        "quests": quests,
        "total_count": len(quests)
    }

@router.get("/{quest_id}", response_model=QuestDetail)
def get_quest(quest_id: int, db: Session = Depends(get_db)):
    """クエスト詳細"""
    try:
        quest = get_quest_detail(db, quest_id)
        if not quest:
            raise HTTPException(status_code=404, detail="クエストが見つかりません")
        return quest
    except Exception as e:
        print(f"Error getting quest {quest_id}: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/apply", response_model=QuestApplyResponse)
def apply_to_quest(request: QuestApplyRequest, db: Session = Depends(get_db)):
    """クエストに応募"""
    user_id = get_current_user_id()
    success, message = apply_quest(db, user_id, request.quest_id)
    if not success:
        raise HTTPException(status_code=400, detail=message)
    return {"success": success, "message": message}

# V2 エンドポイント（新規追加）
@router.get("/v2/available", response_model=QuestListResponseV2)
def get_available_quests_v2(db: Session = Depends(get_db)):
    """応募可能なクエスト一覧 (v2)"""
    user_id = get_current_user_id()
    quests = get_quest_list_v2(db, user_id, "available")
    return {
        "status": "available",
        "quests": quests,
        "total_count": len(quests)
    }

@router.get("/v2/in-progress", response_model=QuestListResponseV2)
def get_in_progress_quests_v2(db: Session = Depends(get_db)):
    """進行中のクエスト一覧 (v2)"""
    user_id = get_current_user_id()
    quests = get_quest_list_v2(db, user_id, "in_progress")
    return {
        "status": "in_progress",
        "quests": quests,
        "total_count": len(quests)
    }

@router.get("/v2/upcoming", response_model=QuestListResponseV2)
def get_upcoming_quests_v2(db: Session = Depends(get_db)):
    """まもなく解放されるクエスト一覧 (v2)"""
    user_id = get_current_user_id()
    quests = get_upcoming_quests_v2_crud(db, user_id)
    return {
        "status": "upcoming",
        "quests": quests,
        "total_count": len(quests)
    }
