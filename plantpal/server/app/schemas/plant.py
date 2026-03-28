from pydantic import BaseModel
from datetime import date
from typing import Optional

class PlantCreate(BaseModel):
    name: str
    species: str
    purchase_date: date | None = None
    location: str | None = None
    category_id: int
    photo_url: str | None = None

class PlantRead(PlantCreate):
    id: int
    class Config: from_attributes = True

class PlantUpdate(BaseModel):
    name: str | None = None
    location: str | None = None
    photo_url: str | None = None
