from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class CareLogCreate(BaseModel):
    action: str
    notes: Optional[str] = None

class CareLogRead(CareLogCreate):
    id: int
    plant_id: int
    date: datetime
    class Config: from_attributes = True
