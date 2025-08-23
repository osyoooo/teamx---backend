from sqlalchemy.orm import Session
from sqlalchemy import and_
from datetime import date
from app.models import Quest, UserQuest, User, QuestSkill, QuestBenefit

def format_skills_display(skills):
    """スキルをテキスト形式でフォーマット"""
    if not skills:
        return ""
    
    skill_parts = []
    for skill in skills:
        # レベル表記の変換
        level_text = ""
        if skill.skill_level == "beginner":
            level_text = "（初級）"
        elif skill.skill_level == "intermediate":
            level_text = "（中級）"
        elif skill.skill_level == "advanced":
            level_text = "（上級）"
        
        # 最後のスキルの場合のみレベルを付ける
        if skill == skills[-1] and level_text:
            skill_parts.append(f"{skill.skill_name}{level_text}")
        else:
            skill_parts.append(skill.skill_name)
    
    return " / ".join(skill_parts)

def get_quest_list(db: Session, user_id: int, status: str):
    """クエスト一覧を取得（スキルと特典情報付き）"""
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
        
        # スキルと特典を取得
        skills = db.query(QuestSkill).filter(QuestSkill.quest_id == quest.id).all()
        benefits = db.query(QuestBenefit).filter(QuestBenefit.quest_id == quest.id).all()
        
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
            "quest_type": quest.quest_type or "quest",
            "prerequisite_text": quest.prerequisite_text or "",
            "prerequisite_score": quest.prerequisite_score or 0,
            "skills": [{"skill_name": s.skill_name, "skill_type": s.skill_type, "skill_level": s.skill_level} for s in skills],
            "benefits": [{"benefit_name": b.benefit_name, "benefit_type": b.benefit_type} for b in benefits],
            "recommended_skills": format_skills_display(skills)
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
        "prerequisite_text": quest.prerequisite_text or "",
        "quest_type": quest.quest_type or "quest",
        "skills": [{"skill_name": s.skill_name, "skill_type": s.skill_type, "skill_level": s.skill_level} for s in skills],
        "benefits": [{"benefit_name": b.benefit_name, "benefit_type": b.benefit_type} for b in benefits],
        "recommended_skills": format_skills_display(skills)
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
    """まもなく解放されるクエスト一覧（スキルと特典情報付き）"""
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
        # スキルと特典を取得
        skills = db.query(QuestSkill).filter(QuestSkill.quest_id == quest.id).all()
        benefits = db.query(QuestBenefit).filter(QuestBenefit.quest_id == quest.id).all()
        
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
            "unlock_message": f"あと{score_diff}点で解放",
            "prerequisite_text": quest.prerequisite_text or "",
            "prerequisite_score": quest.prerequisite_score or 0,
            "skills": [{"skill_name": s.skill_name, "skill_type": s.skill_type, "skill_level": s.skill_level} for s in skills],
            "benefits": [{"benefit_name": b.benefit_name, "benefit_type": b.benefit_type} for b in benefits],
            "recommended_skills": format_skills_display(skills)
        })
    
    return result

# V2 API用の新しい関数
def get_quest_list_v2(db: Session, user_id: int, status: str):
    """クエスト一覧を取得（改善版）"""
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
        
        # スキルと特典を取得
        skills = db.query(QuestSkill).filter(QuestSkill.quest_id == quest.id).all()
        benefits = db.query(QuestBenefit).filter(QuestBenefit.quest_id == quest.id).all()
        
        # 期間計算
        if quest.duration_months and quest.duration_months >= 1:
            duration_display = f"{int(quest.duration_months)}ヶ月"
        else:
            duration_display = f"{int((quest.duration_months or 0) * 4)}週間"
        
        # 締切までの日数
        days_until = (quest.deadline - date.today()).days if quest.deadline else 999
        
        result.append({
            "id": quest.id,
            "title": quest.title or "",
            "objective": quest.objective or "",
            "description": quest.description or "",
            "difficulty_level": quest.difficulty_level or 1,
            "provider_name": quest.provider_name or "",
            "quest_type": quest.quest_type or "quest",
            
            # 表示用フォーマット済みデータ
            "duration_display": duration_display,
            "participants_display": f"{quest.current_participants or 0}名",
            "points_display": f"+{quest.total_points or 0}",
            "recommended_skills_display": format_skills_display(skills),
            
            # 生データ
            "duration_months": float(quest.duration_months) if quest.duration_months else 0,
            "max_participants": quest.max_participants,
            "current_participants": quest.current_participants or 0,
            "points": {
                "find": quest.points_find or 0,
                "shape": quest.points_shape or 0,
                "deliver": quest.points_deliver or 0,
                "total": quest.total_points or 0
            },
            
            # 条件・締切
            "deadline": quest.deadline,
            "days_until_deadline": days_until,
            "is_urgent": days_until <= 7,
            "prerequisite_text": quest.prerequisite_text or "",
            "prerequisite_score": quest.prerequisite_score or 0,
            
            # マッチング情報
            "match_rate": quest.match_rate or 0,
            "can_apply": (
                not user_quest and 
                user.current_total_score >= (quest.prerequisite_score or 0) and
                (not quest.max_participants or quest.current_participants < quest.max_participants)
            ),
            "user_status": user_quest.status if user_quest else None,
            
            # 構造化データ
            "skills": [{"name": s.skill_name, "type": s.skill_type, "level": s.skill_level} for s in skills],
            "benefits": [{"name": b.benefit_name, "type": b.benefit_type} for b in benefits]
        })
    
    return result

def get_upcoming_quests_v2(db: Session, user_id: int):
    """まもなく解放されるクエスト一覧（改善版）"""
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
        # スキルと特典を取得
        skills = db.query(QuestSkill).filter(QuestSkill.quest_id == quest.id).all()
        benefits = db.query(QuestBenefit).filter(QuestBenefit.quest_id == quest.id).all()
        
        # 期間計算
        if quest.duration_months and quest.duration_months >= 1:
            duration_display = f"{int(quest.duration_months)}ヶ月"
        else:
            duration_display = f"{int((quest.duration_months or 0) * 4)}週間"
        
        # 締切までの日数
        days_until = (quest.deadline - date.today()).days if quest.deadline else 999
        
        # 必要スコアまでの差分
        score_diff = (quest.prerequisite_score or 0) - user.current_total_score
        
        result.append({
            "id": quest.id,
            "title": quest.title or "",
            "objective": quest.objective or "",
            "description": quest.description or "",
            "difficulty_level": quest.difficulty_level or 1,
            "provider_name": quest.provider_name or "",
            "quest_type": quest.quest_type or "quest",
            
            # 表示用フォーマット済みデータ
            "duration_display": duration_display,
            "participants_display": f"{quest.current_participants or 0}名",
            "points_display": f"+{quest.total_points or 0}",
            "recommended_skills_display": format_skills_display(skills),
            
            # 生データ
            "duration_months": float(quest.duration_months) if quest.duration_months else 0,
            "max_participants": quest.max_participants,
            "current_participants": quest.current_participants or 0,
            "points": {
                "find": quest.points_find or 0,
                "shape": quest.points_shape or 0,
                "deliver": quest.points_deliver or 0,
                "total": quest.total_points or 0
            },
            
            # 条件・締切
            "deadline": quest.deadline,
            "days_until_deadline": days_until,
            "is_urgent": days_until <= 7,
            "prerequisite_text": quest.prerequisite_text or "",
            "prerequisite_score": quest.prerequisite_score or 0,
            
            # マッチング情報
            "match_rate": quest.match_rate or 0,
            "can_apply": False,
            "user_status": None,
            
            # 追加情報
            "score_diff": score_diff,
            "unlock_message": f"あと{score_diff}点で解放",
            
            # 構造化データ
            "skills": [{"name": s.skill_name, "type": s.skill_type, "level": s.skill_level} for s in skills],
            "benefits": [{"name": b.benefit_name, "type": b.benefit_type} for b in benefits]
        })
    
    return result
