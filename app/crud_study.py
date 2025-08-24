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
          .all()
    )
    return [
        {
            "id": c.id,
            "title": c.title,
            "description": c.description,
            "cover_image_url": c.cover_image_url,
            "provider_name": c.provider.name,
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
    next_goal = ((current_score // 50) + 1) * 50
    progress_percent = int(current_score / next_goal * 100) if next_goal else 0

    histories = (
        db.query(UserLearningHistory)
          .join(LearningContent)
          .join(LearningProvider)
          .filter(UserLearningHistory.user_id == user_id)
          .all()
    )

    ongoing = []
    history_content_ids = []
    for h in histories:
        history_content_ids.append(h.content_id)
        if h.status != "in_progress":
            continue
        earned = h.points_earned_find + h.points_earned_shape + h.points_earned_deliver
        progress = int(earned / h.content.total_score * 100) if h.content.total_score else 0
        ongoing.append({
            "id": h.content.id,
            "title": h.content.title,
            "cover_image_url": h.content.cover_image_url,
            "provider_name": h.content.provider.name,
            "total_score": h.content.total_score,
            "progress_percent": progress,
        })

    rec_contents = (
        db.query(LearningContent)
          .join(LearningProvider)
          .filter(LearningContent.status == "active")
          .filter(~LearningContent.id.in_(history_content_ids))
          .all()
    )
    recommended = [
        {
            "id": c.id,
            "title": c.title,
            "cover_image_url": c.cover_image_url,
            "provider_name": c.provider.name,
            "total_score": c.total_score,
        }
        for c in rec_contents
    ]

    return {
        "goal": {
            "current_score": current_score,
            "next_goal_score": next_goal,
            "progress_percent": progress_percent,
        },
        "ongoing": ongoing,
        "recommended": recommended,
    }
