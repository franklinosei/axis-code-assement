import string
from typing import Optional
from pydantic import EmailStr, constr, validator
from app.schemas import CoreModel, DateTimeModelMixin, IDModelMixin
from app.core.config import settings
from datetime import datetime, timedelta


def validate_username(username: str) -> str:
    allowed = string.ascii_letters + string.digits + '_' + '-'
    assert all(
        char in allowed for char in username), 'Username must contain only letters, digits, underscore, and hyphen'
    assert len(username) >= 3, 'Username must be at least 3 characters long'
    return username


class UserBase(CoreModel):
    """Base user schema"""
    email: Optional[EmailStr]
    is_superuser: Optional[bool] = False
    is_active: bool = None


class UserCreate(CoreModel):
    """User creation schema"""
    email: EmailStr
    password: constr(min_length=7, max_length=100)

    class Config:
        orm_mode = True


class UserToDB(UserBase,  DateTimeModelMixin):
    """User schema for data stored in DB"""
    salt: str
    password: constr(min_length=7, max_length=150)

    class Config:
        orm_mode = True

class UserFromDB( IDModelMixin, UserBase,  DateTimeModelMixin):
    """User schema for data stored in DB"""
    salt: str
    password: constr(min_length=7, max_length=150)


    class Config:
        orm_mode = True


class UserPasswordUpdate(CoreModel):
    """
    Users can change their password
    """
    password: constr(min_length=7, max_length=150)
    salt: str

    class Config:
        orm_mode = True


class JWTMeta(CoreModel):
    iss: str = "azepug.az"
    aud: str = settings.JWT_AUDIENCE
    iat: float = datetime.timestamp(datetime.now())
    exp: float = datetime.timestamp(
        datetime.now() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES))


class JWTCreds(CoreModel):
    """How we'll identify users"""
    sub: EmailStr


class JWTPayload(JWTMeta, JWTCreds):
    """
    JWT Payload right before it's encoded - combine meta and username
    """
    pass


class AccessToken(CoreModel):
    access_token: str
    token_type: str


class TokenData(CoreModel):
    email: Optional[str] = None


class UserPublic(IDModelMixin, UserBase, DateTimeModelMixin):
    """User schema for public data"""

    access_token: Optional[AccessToken]

    class Config:
        orm_mode = True


class UserLogin(CoreModel):
    """
    user email and password are required for logging in the user
    """
    email: EmailStr
    password: constr(min_length=7, max_length=100)


class UserBioData(CoreModel, ):
    """
    Employee data schema
    """
    # user_id: str
    employee_id: str = None
    staff_no: str = None
    appointment_date: datetime = None
    ssnit_no: str = None
    dob: datetime = None
    title: str = None
    surname: str = None
    other_name: str = None
    gender_code: str = None
    marital_status: str = None
    cellphone: str = None
    # email: EmailStr
    address: str = None
    passport_photo: str = None

    class Config:
        orm_mode = True


class UserBioDataInDB(UserBioData):
    user_id: int = None
    # owner: UserFromDB = None

    class Config:
        orm_mode = True


class UserEmploymentData(CoreModel):
    """
    Employment data schema
    """
    employment_date: datetime = None
    designation: str = None
    job_grade: str = None
    employment_type: str = None
    branch: str = None
    hod_name: str = None
    contract_freq_code: str = None
    contract_duration: str = None

    class Config:
        orm_mode = True


class UserEmploymentDataInDB(UserEmploymentData):
    user_id: int = None
    # owner: UserFromDB = None

    class Config:
        orm_mode = True



class FullEmployeeData(UserBase, UserBioDataInDB, UserEmploymentDataInDB):

    class Config:
        orm_mode = True


