from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.plant import PlantCreate, PlantRead, PlantUpdate
from app.models.plant import Plant
from app.dependencies import get_current_user
from app.models.user import User

router = APIRouter(prefix="/plants", tags=["plants"])

@router.post("/", response_model=PlantRead)
def create_plant(plant: PlantCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_plant = Plant(**plant.model_dump())
    db.add(db_plant)
    db.commit()
    db.refresh(db_plant)
    return db_plant

@router.get("/", response_model=list[PlantRead])
def read_plants(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return db.query(Plant).all()

@router.get("/{plant_id}", response_model=PlantRead)
def read_plant(plant_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    plant = db.query(Plant).filter(Plant.id == plant_id).first()
    if not plant:
        raise HTTPException(status_code=404, detail="Plant not found")
    return plant
