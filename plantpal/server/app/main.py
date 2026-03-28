from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine, Base, SessionLocal
from app.models import *
from app.routers import *

app = FastAPI(title="PlantPal API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router)
app.include_router(plants_router)
app.include_router(care_logs_router)   # ← должно быть
app.include_router(categories_router)
app.include_router(stats_router)

@app.on_event("startup")
def startup_event():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    categories = ["Суккуленты", "Тропические", "Цветущие", "Папоротники", "Кактусы", "Пальмы", "Бонсай", "Орхидеи"]
    for name in categories:
        if not db.query(Category).filter(Category.name == name).first():
            db.add(Category(name=name, icon="🌱"))
    db.commit()
    db.close()
    print("✅ PlantPal API started with CORS enabled")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
