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
            "benefits": [{"benefit_name": b.benefit_name, "benefit_type": b.benefit_type} for b in benefits]
        })
    
    return result

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
            "benefits": [{"benefit_name": b.benefit_name, "benefit_type": b.benefit_type} for b in benefits]
        })
    
    return result
