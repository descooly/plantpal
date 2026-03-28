from pydantic import BaseModel

class CategoryRead(BaseModel):
    id: int
    name: str
    icon: str | None
    class Config: from_attributes = True
