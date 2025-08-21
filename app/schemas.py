from pydantic import BaseModel, ConfigDict
from typing import List, Optional
from datetime import date

class QuestListItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    title: str
    objective: str
    description: str
    difficulty_level: int
    provider_name: str
    duration_display: str
    deadline: Optional[date] = None
    participants_display: str
    points_display: str
    match_rate: int
    is_urgent: bool
    can_apply: bool
    user_status: Optional[str] = None
    quest_type: str
    score_diff: Optional[int] = None
    unlock_message: Optional[str] = None

class QuestListResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    status: str
    quests: List[QuestListItem]
    total_count: int

class Skill(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    skill_name: str
    skill_type: str
    skill_level: str

class Benefit(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    benefit_name: str
    benefit_type: str

class QuestDetail(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    title: str
    objective: str
    description: str
    difficulty_level: int
    provider_name: str
    duration_months: float
    deadline: Optional[date] = None
    total_points: int
    match_rate: int
    prerequisite_score: int
    prerequisite_text: Optional[str] = None
    skills: List[Skill]
    benefits: List[Benefit]
    quest_type: str

class QuestApplyRequest(BaseModel):
    quest_id: int

class QuestApplyResponse(BaseModel):
    success: bool
    message: str
