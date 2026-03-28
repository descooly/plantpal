from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.care_log import CareLogCreate, CareLogRead
from app.models.care_log import CareLog
from app.models.plant import Plant
from app.dependencies import get_current_user
from app.models.user import User

router = APIRouter(prefix="/care-logs", tags=["care-logs"])

@router.post("/{plant_id}", response_model=CareLogRead)
def add_care_log(
    plant_id: int, 
    log: CareLogCreate, 
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_user)
):
    plant = db.query(Plant).filter(Plant.id == plant_id).first()
    if not plant:
        raise HTTPException(status_code=404, detail="Plant not found")
    
    db_log = CareLog(plant_id=plant_id, **log.model_dump())
    db.add(db_log)
    db.commit()
    db.refresh(db_log)
    return db_log


@router.get("/{plant_id}", response_model=list[CareLogRead])
def get_care_logs(
    plant_id: int, 
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_user)
):
    # Проверяем, существует ли растение
    plant = db.query(Plant).filter(Plant.id == plant_id).first()
    if not plant:
        raise HTTPException(status_code=404, detail="Plant not found")
    
    logs = db.query(CareLog).filter(CareLog.plant_id == plant_id).order_by(CareLog.date.desc()).all()
    return logs
