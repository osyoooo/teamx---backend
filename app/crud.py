from sqlalchemy.orm import Session
from sqlalchemy import and_
from datetime import date
from app.models import Quest, UserQuest, User, QuestSkill, QuestBenefit

def get_quest_list(db: Session, user_id: int, status: str):
    """クエスト一覧を取得"""
    quests = db.query(Quest).filter(Quest.status == 'available').all()
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        user = User(id=user_id, current_total_score=0)
    
    result = []
    for quest in quests:
        # ユーザーの応募状況を確認
        user_quest = db.query(UserQuest).filter(
            and_(UserQuest.user_id == user_id, UserQuest.quest_id == quest.id)
        ).first()
        
        # フィルタリング
        if status == "available" and user_quest and user_quest.status in ['in_progress', 'completed']:
            continue
        elif status == "in_progress" and (not user_quest or user_quest.status != 'in_progress'):
            continue
        
        # 期間表示
        if quest.duration_months and quest.duration_months >= 1:
            duration_display = f"{int(quest.duration_months)}ヶ月"
        else:
            duration_display = f"{int((quest.duration_months or 0) * 4)}週間"
        
        # 締切までの日数
        if quest.deadline:
            days_until = (quest.deadline - date.today()).days
        else:
            days_until = 999
        
        result.append({
            "id": quest.id,
            "title": quest.title or "",
            "objective": quest.objective or "",
            "description": quest.description or "",
            "difficulty_level": quest.difficulty_level or 1,
            "provider_name": quest.provider_name or "",
            "duration_display": duration_display,
            "deadline": quest.deadline,
            "participants_display": f"{quest.current_participants or 0}名",
            "points_display": f"+{quest.total_points or 0}",
            "match_rate": quest.match_rate or 0,
            "is_urgent": days_until <= 7,
            "can_apply": (
                not user_quest and 
                user.current_total_score >= (quest.prerequisite_score or 0) and
                (not quest.max_participants or quest.current_participants < quest.max_participants)
            ),
            "user_status": user_quest.status if user_quest else None,
            "quest_type": quest.quest_type or "quest"
        })
    
    return result

def get_quest_detail(db: Session, quest_id: int):
    """クエスト詳細を取得"""
    quest = db.query(Quest).filter(Quest.id == quest_id).first()
    if not quest:
        return None
    
    skills = db.query(QuestSkill).filter(QuestSkill.quest_id == quest_id).all()
    benefits = db.query(QuestBenefit).filter(QuestBenefit.quest_id == quest_id).all()
    
    return {
        "id": quest.id,
        "title": quest.title or "",
        "objective": quest.objective or "",
        "description": quest.description or "",
        "difficulty_level": quest.difficulty_level or 1,
        "provider_name": quest.provider_name or "",
        "duration_months": float(quest.duration_months) if quest.duration_months else 0,
        "deadline": quest.deadline,
        "total_points": quest.total_points or 0,
        "match_rate": quest.match_rate or 0,
        "prerequisite_score": quest.prerequisite_score or 0,
        "prerequisite_text": quest.prerequisite_text or "",  # この行が重要
        "quest_type": quest.quest_type or "quest",
        "skills": [{"skill_name": s.skill_name, "skill_type": s.skill_type, "skill_level": s.skill_level} for s in skills],
        "benefits": [{"benefit_name": b.benefit_name, "benefit_type": b.benefit_type} for b in benefits]
    }

def apply_quest(db: Session, user_id: int, quest_id: int):
    """クエストに応募"""
    # 既存チェック
    existing = db.query(UserQuest).filter(
        and_(UserQuest.user_id == user_id, UserQuest.quest_id == quest_id)
    ).first()
    
    if existing:
        return False, "既に応募済みです"
    
    # スコアチェック
    user = db.query(User).filter(User.id == user_id).first()
    quest = db.query(Quest).filter(Quest.id == quest_id).first()
    
    if not user:
        return False, "ユーザーが見つかりません"
    
    if not quest:
        return False, "クエストが見つかりません"
    
    if user.current_total_score < (quest.prerequisite_score or 0):
        return False, f"必要スコアが不足しています（必要: {quest.prerequisite_score}）"
    
    # 応募作成
    user_quest = UserQuest(user_id=user_id, quest_id=quest_id, status='applied')
    db.add(user_quest)
    
    quest.current_participants = (quest.current_participants or 0) + 1
    db.commit()
    
    return True, "応募が完了しました"

def get_upcoming_quests(db: Session, user_id: int):
    """まもなく解放されるクエスト一覧"""
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        return []
    
    # ユーザーのスコアより高い必要スコアのクエストを取得
    quests = db.query(Quest).filter(
        Quest.status == 'available',
        Quest.prerequisite_score > user.current_total_score,
        Quest.prerequisite_score <= user.current_total_score + 150
    ).order_by(Quest.prerequisite_score).all()
    
    result = []
    for quest in quests:
        # 期間表示
        if quest.duration_months and quest.duration_months >= 1:
            duration_display = f"{int(quest.duration_months)}ヶ月"
        else:
            duration_display = f"{int((quest.duration_months or 0) * 4)}週間"
        
        # 締切までの日数
        if quest.deadline:
            days_until = (quest.deadline - date.today()).days
        else:
            days_until = 999
        
        # 必要スコアまでの差分
        score_diff = (quest.prerequisite_score or 0) - user.current_total_score
        
        result.append({
            "id": quest.id,
            "title": quest.title or "",
            "objective": quest.objective or "",
            "description": quest.description or "",
            "difficulty_level": quest.difficulty_level or 1,
            "provider_name": quest.provider_name or "",
            "duration_display": duration_display,
            "deadline": quest.deadline,
            "participants_display": f"{quest.current_participants or 0}名",
            "points_display": f"+{quest.total_points or 0}",
            "match_rate": quest.match_rate or 0,
            "is_urgent": days_until <= 7,
            "can_apply": False,
            "user_status": None,
            "quest_type": quest.quest_type or "quest",
            "score_diff": score_diff,
            "unlock_message": f"あと{score_diff}点で解放"
        })
    
    return result
