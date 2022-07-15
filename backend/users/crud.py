from .schemas import UserBioData, UserBioDataInDB, UserCreate, UserEmploymentDataInDB, UserFromDB, UserPasswordUpdate, UserToDB, UserFromDB, UserPublic
from users import auth_service
from .models import BioData, EmploymentData, User
from app.core.config import settings
from sqlalchemy.orm import Session


def create_user(db: Session, new_user: UserCreate, isAdmin: bool = False) -> UserPublic:
    # generate the hash of the password
    new_password = auth_service.create_salt_and_hash_password(
        plain_text_password=new_user.password)

    # extend user_create schema
    new_user_params = new_user.copy(update=new_password.dict())

    # updated schema passed to UserInDB
    new_user_updated = UserToDB(**new_user_params.dict())
    new_user_updated.is_superuser = isAdmin

    created_user = User(**new_user_updated.dict())

    db.add(created_user)
    db.commit()
    db.refresh(created_user)

    return UserPublic.from_orm(created_user)



def get_user(db: Session, user_id: int) -> UserFromDB:
    found = db.query(User).filter(User.id == user_id).first()
    return UserFromDB.from_orm(found) if found else None
    

def get_user_biodata(db: Session, user_id: int) -> UserBioDataInDB:
    found = db.query(BioData).filter(BioData.user_id == user_id).first()
    return UserBioDataInDB.from_orm(found) if found else None


def get_user_employment_data(db: Session, user_id: int) -> UserEmploymentDataInDB:
    found = db.query(EmploymentData).filter(EmploymentData.user_id == user_id).first()
    return UserEmploymentDataInDB.from_orm(found) if found else None


def get_user_by_email(db: Session, email: str) -> UserFromDB:
    found =  db.query(User).filter(User.email == email).first()
    if found:
        return UserFromDB.from_orm(found)
    return None



async def update_bio_data(user_id: int, bio_data: UserBioData) -> UserFromDB:
    # found_user = await User.query.where(User.id == user_id).gino.first()
    found_user = User.get_or_404(id=user_id)
    # update the user bio data
    found_user.update(**bio_data.dict())
    # save the user
    await found_user.save()
    return UserFromDB.from_orm(found_user)


async def update_employee_data(user_id: int, employee_data: UserBioData) -> UserFromDB:
    # found_user = await User.query.where(User.id == user_id).gino.first()
    found_user = User.get_or_404(id=user_id)
    # update the user bio data
    found_user.update(**employee_data.dict())
    # save the user
    await found_user.save()
    return UserFromDB.from_orm(found_user)


def get_users(db: Session, skip: int = 0, limit: int = 100):
    found = db.query(User).offset(skip).limit(limit).all()
    return found
    # return [UserInDB.from_orm(user) for user in found]
