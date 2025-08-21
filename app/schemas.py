from pydantic import BaseModel
from typing import List, Optional
from datetime import date

class QuestListItem(BaseModel):
    id: int
    title: str
    objective: str
    description: str
    difficulty_level: int
    provider_name: str
    duration_display: str
    deadline: date
    participants_display: str
    points_display: str
    match_rate: int
    is_urgent: bool
    can_apply: bool
    user_status: Optional[str]
    quest_type: str
    
class QuestListResponse(BaseModel):
    status: str
    quests: List[QuestListItem]
    total_count: int

class Skill(BaseModel):
    skill_name: str
    skill_type: str
    skill_level: str

class Benefit(BaseModel):
    benefit_name: str
    benefit_type: str

class QuestDetail(BaseModel):
    id: int
    title: str
    objective: str
    description: str
    difficulty_level: int
    provider_name: str
    duration_months: float
    deadline: date
    total_points: int
    match_rate: int
    prerequisite_score: int
    prerequisite_text: Optional[str]
    skills: List[Skill]
    benefits: List[Benefit]
    quest_type: str

class QuestApplyRequest(BaseModel):
    quest_id: int

class QuestApplyResponse(BaseModel):
    success: bool
    message: str