from sqlalchemy import Column, Integer, String, Text, Enum, DECIMAL, Date, TIMESTAMP, ForeignKey, Boolean, BigInteger
from sqlalchemy.sql import func
from app.database import Base

class Quest(Base):
    __tablename__ = "quests"
    
    id = Column(Integer, primary_key=True)
    title = Column(String(255))
    objective = Column(Text)
    description = Column(Text)
    difficulty_level = Column(Integer)
    difficulty_name = Column(String(50))
    provider_id = Column(BigInteger)  # BigIntegerに修正
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

class UserQuest(Base):
    __tablename__ = "user_quests"
    
    id = Column(Integer, primary_key=True)
    user_id = Column(BigInteger)  # BigIntegerに修正
    quest_id = Column(Integer)
    status = Column(String(50))
    progress_percentage = Column(Integer)
    applied_at = Column(TIMESTAMP)

class User(Base):
    __tablename__ = "users"
    
    id = Column(BigInteger, primary_key=True)  # BigIntegerに修正
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
