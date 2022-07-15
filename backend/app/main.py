import os
from .helpers import get_db
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from starlette.middleware.cors import CORSMiddleware
from users.api.v1 import router as user_router

from app.core.config import settings
from users.crud import create_user, get_user_by_email
from users.schemas import UserCreate
from .database import engine
from users.models import Base
from sqlalchemy.orm import Session

def create_superuser(db: Session):
    admin = UserCreate(
        email = "admin@admin.com",
        password = "admin1234"
    )

    found_admin = get_user_by_email(db=db, email= admin.email)
    
    if not found_admin:
        print('Adding admin...')
        res = create_user(db, admin, isAdmin=True)
    print("admin already added")
        


def get_application():
    
    Base.metadata.create_all(bind=engine)

    _app = FastAPI(title=settings.PROJECT_NAME)

    @_app.on_event("startup")
    async def startup():
        print("app started")


    @_app.on_event("shutdown")
    async def shutdown():
        print("SHUTDOWN")


    _app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    create_superuser(next(get_db()))

    return _app

# print(get_db().__anext__())

BASEDIR = os.path.dirname(__file__)

app = get_application()
app.include_router(user_router, prefix='/employee')
app.mount("/static", StaticFiles(directory=BASEDIR + "/statics"), name="static")