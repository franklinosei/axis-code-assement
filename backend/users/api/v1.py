from datetime import datetime
from telnetlib import STATUS
from fastapi import APIRouter, Depends, HTTPException, Form, UploadFile, File
from fastapi.responses import JSONResponse
from users.crud import get_user, get_user_biodata, get_user_by_email, get_user_employment_data
from users.models import BioData, EmploymentData
# from users.models import BioData, EmploymentData
from ..schemas import AccessToken, FullEmployeeData, UserBioData, UserBioDataInDB, UserCreate, UserEmploymentDataInDB, UserFromDB, UserToDB, UserLogin, UserPublic, UserEmploymentData
from .. import auth_service
from users import get_current_active_user, check_if_user_is_admin
from typing import List
from app.helpers import get_db, handle_file_upload
from sqlalchemy.orm import Session


router = APIRouter()



@router.post(
            '/login',
            tags=['employee login'],
            description='Login employee',
            response_model=UserPublic,
            
)
async def login_user(user: UserLogin, db: Session = Depends(get_db)) -> UserPublic:
    from ..crud import get_user_by_email

    found_user = get_user_by_email(db, email=user.email)

    if not found_user:
        raise HTTPException(status_code=400, detail="Invalid email or password")

    if auth_service.verify_password(password=user.password, salt=found_user.salt, hashed_password=found_user.password):
        # If the provided password is valid one then we are going to create an access token
        token = auth_service.create_access_token_for_user(user=found_user)
        access_token = AccessToken(access_token=token, token_type='bearer')
        return UserPublic(**found_user.dict(), access_token=access_token)
    
    return JSONResponse(status_code=400, content={"detail": "Invalid email or password"})


# Working
@router.post(
            '/add-employee',
             tags=['employee registration'],
             response_model=UserPublic,
             description='Register new employee',
             dependencies=[Depends(check_if_user_is_admin)]
             )
def create_user(user: UserCreate, db: Session = Depends(get_db)) -> UserPublic:
    from ..crud import create_user, get_user_by_email
    found_user = get_user_by_email(db, email=user.email)
    if found_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return create_user(db, user)


#  Working
@router.get(
            '/get-employees', 
            tags=['get all employee data'], 
            response_model=List[FullEmployeeData], 
            description='Get all employee data', 
            # dependencies=[Depends(check_if_user_is_admin)]
            )
async def get_employees(db: Session = Depends(get_db)) -> FullEmployeeData:
    from ..crud import get_users
    try:
        found = get_users(db)
        return [FullEmployeeData.from_orm(user) for user in found]
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))





@router.post(
            '/update-biodata', 
            tags=['update employee biodata'], 
            # response_model=UserBioData, 
            description='update employee biodata', 
            dependencies=[Depends(get_current_active_user)]
            )
async def update_user_data(
                            employee_id: str = Form(...),
                            staff_no: str = Form(...),
                            appointment_date: datetime = Form(...),
                            ssnit_no: str = Form(...),
                            dob: datetime = Form(...),
                            title: str = Form(...),
                            surname: str = Form(...),
                            other_name: str = Form(...),
                            gender_code: str = Form(...),
                            marital_status: str = Form(...),
                            cellphone: str = Form(...),
                            address: str = Form(...),
                            passport_photo: UploadFile = Form(...),
                            db: Session = Depends(get_db),
                            current_user: UserFromDB = Depends(get_current_active_user),
                            ) -> str:

    try:

        found_user = get_user(db, user_id=current_user.id)

        if not found_user:
            raise HTTPException(status_code=404, detail="User does not exist")
        
        bio = UserBioDataInDB(
            employee_id=employee_id,
            staff_no=staff_no,
            appointment_date=appointment_date,
            ssnit_no=ssnit_no,
            dob=dob,
            title=title,
            surname=surname,
            other_name=other_name,
            gender_code = gender_code,
            marital_status = marital_status,
            cellphone = cellphone,
            address = address,
            passport_photo = ''
        )
        bio.user_id = found_user.id
        bio.passport_photo = await handle_file_upload(passport_photo)

        bio_data = bio.dict()
        user_bio = BioData(**bio_data)
        db.add(user_bio)
        db.commit()
        db.refresh(user_bio)

        return "User data updated successfully"

    except Exception as e:
        print(e)
        raise HTTPException(status_code=400, detail=str(e))




@router.post(
            '/update-employment-data', 
            tags=["update employee's employment data"], 
            # response_model=UserEmploymentData, 
            description='update employee data', 
            dependencies=[Depends(get_current_active_user)]
            )
async def update_user_emp_data(
                            data: UserEmploymentData, 
                            db: Session = Depends(get_db),
                            current_user: UserFromDB = Depends(get_current_active_user),
                            ) -> str:

    found_user = get_user(db, user_id=current_user.id)

    if not found_user:
        raise HTTPException(status_code=400, detail="User does not exist")
    
    empl_data = UserEmploymentDataInDB.from_orm(data)
    empl_data.user_id = current_user.id
    empl_data = empl_data.dict()
    user_empl_data = EmploymentData(**empl_data)
    db.add(user_empl_data)
    db.commit()
    db.refresh(user_empl_data)
    return "User data updated successfully"



@router.get(
    "/profile",
    tags=["get current logged in user"],
    description="Get current logged in user",
    response_model=FullEmployeeData,
)
async def get_me(current_user: UserFromDB = Depends(get_current_active_user), db: Session = Depends(get_db)) -> FullEmployeeData:
    data = {}
    user = get_user(db, user_id=current_user.id)
    if not user:
        raise HTTPException(status_code=400, detail="User does not exist")

    bio = get_user_biodata(db, user_id=user.id)
    if not bio:
        raise HTTPException(status_code=400, detail="User biodata does not exist")

    emp_data = get_user_employment_data(db, user_id=user.id)
    if not emp_data:
        raise HTTPException(status_code=400, detail="User employment data does not exist")

    data.update(user.dict())
    data.update(bio.dict())
    data.update(emp_data.dict())

    return FullEmployeeData(**data)


@router.get('/logout', tags=['logout'], description='Logout')
async def logout(current_user: UserFromDB = Depends(get_current_active_user), db: Session = Depends(get_db)) -> str:
    try:
        return "Logout successful"
    except Exception as e:
        raise HTTPException(status_code=400, detail=e)



@router.get(
    "/biodata-status",
    tags=["get current logged in user"],
    description="Get current logged in user",
    response_model=FullEmployeeData,
)
async def get_me(current_user: UserFromDB = Depends(get_current_active_user), db: Session = Depends(get_db)) -> FullEmployeeData:
    bio = get_user_biodata(db, user_id=current_user.id)
    return JSONResponse(status_code=200, content={"status": bio != None})



@router.get(
    "/employment-data-status",
    tags=["get current logged in user"],
    description="Get current logged in user",
    response_model=FullEmployeeData,
)
async def get_me(current_user: UserFromDB = Depends(get_current_active_user), db: Session = Depends(get_db)) -> FullEmployeeData:
    empl = get_user_employment_data(db, user_id=current_user.id)
    return JSONResponse(status_code=200, content={"status": empl != None})

