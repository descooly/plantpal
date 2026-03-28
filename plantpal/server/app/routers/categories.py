from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.category import CategoryRead
from app.models.category import Category
from app.dependencies import get_current_user
from app.models.user import User

router = APIRouter(prefix="/categories", tags=["categories"])

@router.get("/", response_model=list[CategoryRead])
def get_categories(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return db.query(Category).all()
