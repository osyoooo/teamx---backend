from sqlalchemy import Column, Integer, String, Text, Enum, DECIMAL, Date, TIMESTAMP, ForeignKey, Boolean, BigInteger
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database import Base

# ---------- Existing Quest models ----------
class Quest(Base):
    __tablename__ = "quests"

    id = Column(Integer, primary_key=True)
    title = Column(String(255))
    objective = Column(Text)
    description = Column(Text)
    difficulty_level = Column(Integer)
    difficulty_name = Column(String(50))
    provider_id = Column(BigInteger)
    provider_name = Column(String(255))
    duration_months = Column(DECIMAL(3, 1))
    deadline = Column(Date)
    max_participants = Column(Integer)
    current_participants = Column(Integer)
    points_find = Column(Integer)
    points_shape = Column(Integer)
    points_deliver = Column(Integer)
    total_points = Column(Integer)
    status = Column(String(50))
    match_rate = Column(Integer)
    quest_type = Column(String(50))
    prerequisite_score = Column(Integer)
    prerequisite_text = Column(Text)

class UserQuest(Base):
    __tablename__ = "user_quests"

    id = Column(Integer, primary_key=True)
    user_id = Column(BigInteger)
    quest_id = Column(Integer)
    status = Column(String(50))
    progress_percentage = Column(Integer)
    applied_at = Column(TIMESTAMP)

class User(Base):
    __tablename__ = "users"

    id = Column(BigInteger, primary_key=True)
    display_name = Column(String(100))
    current_total_score = Column(Integer)

class QuestSkill(Base):
    __tablename__ = "quest_skills"

    id = Column(Integer, primary_key=True)
    quest_id = Column(Integer)
    skill_name = Column(String(100))
    skill_type = Column(String(50))
    skill_level = Column(String(50))

class QuestBenefit(Base):
    __tablename__ = "quest_benefits"

    id = Column(Integer, primary_key=True)
    quest_id = Column(Integer)
    benefit_name = Column(String(255))
    benefit_type = Column(String(50))

# ---------- New Study models ----------
class LearningProvider(Base):
    __tablename__ = "learning_providers"

    id = Column(BigInteger, primary_key=True)
    name = Column(String(255), nullable=False)
    website_url = Column(String(255))
    provider_type = Column(
        Enum("platform", "university", "company", "npo", "government", name="provider_type_enum"),
        default="platform"
    )

class LearningContent(Base):
    __tablename__ = "learning_contents"

    id = Column(BigInteger, primary_key=True)
    title = Column(String(255), nullable=False)
    description = Column(Text)
    cover_image_url = Column(String(512))
    provider_id = Column(BigInteger, ForeignKey("learning_providers.id"))
    difficulty_level = Column(Integer, default=1)
    duration_minutes = Column(Integer, default=0)
    points_find = Column(Integer, default=0)
    points_shape = Column(Integer, default=0)
    points_deliver = Column(Integer, default=0)
    reward_amount = Column(Integer, default=0)
    total_score = Column(Integer)  # generated column in DB
    unlock_condition = Column(Text)
    required_total_score = Column(Integer, default=0)
    prerequisite_content_id = Column(BigInteger, ForeignKey("learning_contents.id"))
    status = Column(Enum("active", "draft", "archived", name="lc_status_enum"), default="active")
    created_at = Column(TIMESTAMP, server_default=func.now())

    provider = relationship("LearningProvider", backref="contents")

class LearningContentSkill(Base):
    __tablename__ = "learning_content_skills"

    id = Column(BigInteger, primary_key=True)
    content_id = Column(BigInteger, ForeignKey("learning_contents.id"))
    skill_id = Column(BigInteger)

class UserLearningHistory(Base):
    __tablename__ = "user_learning_history"

    id = Column(BigInteger, primary_key=True)
    user_id = Column(BigInteger, ForeignKey("users.id"), nullable=False)
    content_id = Column(BigInteger, ForeignKey("learning_contents.id"))
    school_year = Column(String(16))
    activity_type = Column(String(64))
    activity_title = Column(String(255))
    period_months = Column(DECIMAL(3, 2))
    points_earned_find = Column(Integer, default=0)
    points_earned_shape = Column(Integer, default=0)
    points_earned_deliver = Column(Integer, default=0)
    reward_amount = Column(Integer, default=0)
    total_score_at_time = Column(Integer, default=0)
    status = Column(
        Enum("completed", "in_progress", "available", "locked", name="ulh_status_enum"),
        default="available"
    )
    completed_at = Column(TIMESTAMP)
    created_at = Column(TIMESTAMP, server_default=func.now())

    content = relationship("LearningContent")
