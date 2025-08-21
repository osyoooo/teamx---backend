from sqlalchemy.orm import Session
from sqlalchemy import and_
from datetime import date
from app.models import Quest, UserQuest, User, QuestSkill, QuestBenefit

def get_quest_list(db: Session, user_id: int, status: str):
    """クエスト一覧を取得"""
    quests = db.query(Quest).filter(Quest.status == 'available').all()
    user = db.query(User).filter(User.id == user_id).first()
    
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
        duration_display = f"{int(quest.duration_months)}ヶ月" if quest.duration_months >= 1 else f"{int(quest.duration_months * 4)}週間"
        
        # 締切までの日数
        days_until = (quest.deadline - date.today()).days if quest.deadline else 999
        
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
            "can_apply": (
                not user_quest and 
                user.current_total_score >= quest.prerequisite_score and
                (not quest.max_participants or quest.current_participants < quest.max_participants)
            ),
            "user_status": user_quest.status if user_quest else None,
            "quest_type": quest.quest_type
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
        "title": quest.title,
        "objective": quest.objective,
        "description": quest.description,
        "difficulty_level": quest.difficulty_level,
        "provider_name": quest.provider_name,
        "duration_months": quest.duration_months,
        "deadline": quest.deadline,
        "total_points": quest.total_points,
        "match_rate": quest.match_rate,
        "prerequisite_score": quest.prerequisite_score,
        "prerequisite_text": quest.prerequisite_text,
        "quest_type": quest.quest_type,
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
    
    if user.current_total_score < quest.prerequisite_score:
        return False, f"必要スコアが不足しています（必要: {quest.prerequisite_score}）"
    
    # 応募作成
    user_quest = UserQuest(user_id=user_id, quest_id=quest_id, status='applied')
    db.add(user_quest)
    
    quest.current_participants += 1
    db.commit()
    
    return True, "応募が完了しました"