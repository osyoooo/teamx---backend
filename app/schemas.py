from pydantic import BaseModel, ConfigDict
from typing import List, Optional
from datetime import date

class Skill(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    skill_name: str
    skill_type: str
    skill_level: str

class Benefit(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    benefit_name: str
    benefit_type: str

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
    prerequisite_text: Optional[str] = None
    prerequisite_score: int = 0
    skills: List[Skill] = []
    benefits: List[Benefit] = []
    recommended_skills: str = ""

class QuestListResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    status: str
    quests: List[QuestListItem]
    total_count: int

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
    recommended_skills: str = ""

class QuestApplyRequest(BaseModel):
    quest_id: int

class QuestApplyResponse(BaseModel):
    success: bool
    message: str

# V2 API用の新しいスキーマ
class SkillV2(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    name: str
    type: str
    level: str

class BenefitV2(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    name: str
    type: str

class PointsInfo(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    find: int
    shape: int
    deliver: int
    total: int

class QuestListItemV2(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    # 基本情報
    id: int
    title: str
    objective: str
    description: str
    difficulty_level: int
    provider_name: str
    quest_type: str
    
    # 表示用フォーマット済み
    duration_display: str
    participants_display: str
    points_display: str
    recommended_skills_display: str
    
    # 生データ
    duration_months: float
    max_participants: Optional[int] = None
    current_participants: int
    points: PointsInfo
    
    # 条件・締切
    deadline: Optional[date] = None
    days_until_deadline: int
    is_urgent: bool
    prerequisite_text: str
    prerequisite_score: int
    
    # マッチング情報
    match_rate: int
    can_apply: bool
    user_status: Optional[str] = None
    
    # 追加情報（upcomingの場合）
    score_diff: Optional[int] = None
    unlock_message: Optional[str] = None
    
    # 構造化データ
    skills: List[SkillV2]
    benefits: List[BenefitV2]

class QuestListResponseV2(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    status: str
    quests: List[QuestListItemV2]
    total_count: int
