from sqlalchemy.orm import Session
from app.models import (
    LearningContent,
    LearningProvider,
    UserLearningHistory,
    User,
)

def get_all_learning_contents(db: Session):
    contents = (
        db.query(LearningContent)
          .join(LearningProvider, LearningContent.provider_id == LearningProvider.id)
          .filter(LearningContent.status == "active")
          .all()
    )
    return [
        {
            "id": c.id,
            "title": c.title,
            "description": c.description,
            "cover_image_url": c.cover_image_url,
            "provider_name": c.provider.name if c.provider else None,
            "difficulty_level": c.difficulty_level,
            "duration_minutes": c.duration_minutes,
            "points_find": c.points_find,
            "points_shape": c.points_shape,
            "points_deliver": c.points_deliver,
            "reward_amount": c.reward_amount,
            "total_score": c.total_score,
        }
        for c in contents
    ]

def get_study_dashboard(db: Session, user_id: int):
    user = db.query(User).filter(User.id == user_id).first()
    current_score = user.current_total_score if user else 0
    
    # 次のゴールを計算（50点刻み）
    next_goal = ((current_score // 50) + 1) * 50
    
    # 前のゴールを計算
    previous_goal = (current_score // 50) * 50
    
    # 現在の区間での進捗率を計算（前のゴールから次のゴールまでの間での進捗）
    if next_goal > previous_goal:
        progress_in_current_segment = current_score - previous_goal
        total_segment = next_goal - previous_goal
        progress_percent = int((progress_in_current_segment / total_segment) * 100)
    else:
        progress_percent = 0
    
    # 次のゴールまでの残り%を計算
    remaining_percent = 100 - progress_percent

    histories = (
        db.query(UserLearningHistory)
          .join(LearningContent, UserLearningHistory.content_id == LearningContent.id)
          .join(LearningProvider, LearningContent.provider_id == LearningProvider.id)
          .filter(UserLearningHistory.user_id == user_id)
          .filter(UserLearningHistory.content_id.isnot(None))
          .all()
    )

    ongoing = []
    history_content_ids = []
    for h in histories:
        if h.content_id:
            history_content_ids.append(h.content_id)
        if h.status == "in_progress" and h.content:
            earned = h.points_earned_find + h.points_earned_shape + h.points_earned_deliver
            progress = int(earned / h.content.total_score * 100) if h.content.total_score else 0
            ongoing.append({
                "id": h.content.id,
                "title": h.content.title,
                "cover_image_url": h.content.cover_image_url,
                "provider_name": h.content.provider.name if h.content.provider else None,
                "total_score": h.content.total_score,
                "progress_percent": progress,
            })

    # 履歴に含まれていないコンテンツを推奨として取得
    rec_contents_query = (
        db.query(LearningContent)
          .join(LearningProvider, LearningContent.provider_id == LearningProvider.id)
          .filter(LearningContent.status == "active")
    )
    
    if history_content_ids:
        rec_contents_query = rec_contents_query.filter(~LearningContent.id.in_(history_content_ids))
    
    rec_contents = rec_contents_query.all()
    
    recommended = [
        {
            "id": c.id,
            "title": c.title,
            "cover_image_url": c.cover_image_url,
            "provider_name": c.provider.name if c.provider else None,
            "total_score": c.total_score,
        }
        for c in rec_contents
    ]

    return {
        "goal": {
            "current_score": current_score,
            "next_goal_score": next_goal,
            "progress_percent": progress_percent,
            "remaining_percent": remaining_percent,  # 追加
            "remaining_text": f"次のゴールまであと{remaining_percent}%"  # 追加
        },
        "ongoing": ongoing,
        "recommended": recommended,
    }
