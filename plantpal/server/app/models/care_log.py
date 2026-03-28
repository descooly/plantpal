from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base
from datetime import datetime

class CareLog(Base):
    __tablename__ = "care_logs"
    id = Column(Integer, primary_key=True, index=True)
    plant_id = Column(Integer, ForeignKey("plants.id"))
    action = Column(String)  # "полив", "удобрение", "пересадка"...
    date = Column(DateTime, default=datetime.utcnow)
    notes = Column(String, nullable=True)
    plant = relationship("Plant", back_populates="care_logs")
