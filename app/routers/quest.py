from fastapi import APIRouter, Depends, HTTPException, Path  # Pathを追加
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
def get_quest(
    quest_id: int = Path(..., description="クエストID"),  # Path()を明示的に使用
    db: Session = Depends(get_db)
):
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

@router.get("/upcoming", response_model=QuestListResponse)
def get_upcoming_quests(db: Session = Depends(get_db)):
    """まもなく解放されるクエスト一覧（必要スコアに近いもの）"""
    user_id = get_current_user_id()
    user = db.query(User).filter(User.id == user_id).first()
    
    # ユーザーのスコアより高い必要スコアのクエストを取得
    quests = db.query(Quest).filter(
        Quest.status == 'available',
        Quest.prerequisite_score > user.current_total_score,
        Quest.prerequisite_score <= user.current_total_score + 150  # 150点以内
    ).order_by(Quest.prerequisite_score).all()
    
    result = []
    for quest in quests:
        # 期間表示
        duration_display = f"{int(quest.duration_months)}ヶ月" if quest.duration_months >= 1 else f"{int(quest.duration_months * 4)}週間"
        
        # 締切までの日数
        days_until = (quest.deadline - date.today()).days if quest.deadline else 999
        
        # 必要スコアまでの差分
        score_diff = quest.prerequisite_score - user.current_total_score
        
        result.append({
            "id": quest.id,
            "title": quest.title,
            "objective": quest.objective,
            "description": quest.description,
            "difficulty_level": quest.difficulty_level,
            "provider_name": quest.provider_name,
            "duration_display": duration_display,
            "deadline": quest.deadline,
            "participants_display": f"{quest.current_participants}名",
            "points_display": f"+{quest.total_points}",
            "match_rate": quest.match_rate,
            "is_urgent": days_until <= 7,
            "can_apply": False,  # まだ応募できない
            "user_status": None,
            "quest_type": quest.quest_type,
            "score_diff": score_diff,  # 追加：必要スコアまでの差分
            "unlock_message": f"あと{score_diff}点で解放"  # 追加：解放メッセージ
        })
    
    return {
        "status": "upcoming",
        "quests": result,
        "total_count": len(result)
    }
