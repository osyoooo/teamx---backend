from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas import StudyDashboardResponse, LearningContentResponse
from app import crud_study

router = APIRouter(prefix="/study", tags=["study"])

def get_current_user_id() -> int:
    # TODO: Replace with real authentication
    return 1

@router.get("/dashboard", response_model=StudyDashboardResponse)
def read_dashboard(db: Session = Depends(get_db)):
    user_id = get_current_user_id()
    return crud_study.get_study_dashboard(db, user_id)

@router.get("/contents", response_model=list[LearningContentResponse])
def list_contents(db: Session = Depends(get_db)):
    return crud_study.get_all_learning_contents(db)
