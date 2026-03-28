from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.models.care_log import CareLog
from sqlalchemy import func
from datetime import datetime

router = APIRouter(prefix="/stats", tags=["stats"])

@router.get("/care-by-month")
def care_by_month(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = db.query(
        func.date_trunc('month', CareLog.date).label('month'),
        func.count(CareLog.id).label('count')
    ).group_by('month').order_by('month').all()
    return [{"month": r.month.strftime("%Y-%m"), "count": r.count} for r in result]
