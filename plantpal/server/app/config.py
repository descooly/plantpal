from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    secret_key: str = "super-secret-key-change-in-prod"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 60 * 24 * 7  # 7 дней

    class Config:
        env_file = ".env"

settings = Settings()
