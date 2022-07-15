from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, Unicode, DateTime
from sqlalchemy.orm import relationship

from app.database import Base


class User(Base):

    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    salt = Column(String)
    is_superuser = Column(Boolean, default=False)
    password = Column(Unicode)
    created_at = Column(DateTime)
    updated_at = Column(DateTime)
    is_active = Column(Boolean, default=True)

    biodata = relationship("BioData", back_populates="owner", uselist = False)
    employment_data = relationship("EmploymentData", back_populates="owner", uselist = False)



class BioData(Base):

    __tablename__ = "employee_biodata"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True, nullable=True)
    employee_id = Column(String, unique=True, nullable=True)
    staff_no = Column(String, unique=True, nullable=True)
    appointment_date = Column(DateTime, nullable=True)
    ssnit_no = Column(String, unique=True, nullable=True)
    dob = Column(DateTime, nullable=True)
    title = Column(String, nullable=True)
    surname = Column(String, nullable=True)
    other_name = Column(String, nullable=True)
    gender_code = Column(String, nullable=True)
    marital_status = Column(String, nullable=True)
    cellphone = Column(String, nullable=True)
    address = Column(String, nullable=True)
    passport_photo = Column(String, nullable=True)

    user_id = Column(Integer, ForeignKey("users.id"))
    owner = relationship("User", back_populates="biodata")




class EmploymentData(Base):

    __tablename__ = "employee_employment_data"

    id = Column(Integer, primary_key=True, index=True)
    employment_date = Column(DateTime, nullable=True)
    designation = Column(String, nullable=True)
    job_grade = Column(String, nullable=True)
    employment_type = Column(String, nullable=True)
    branch = Column(String, nullable=True)
    hod_name = Column(String, nullable=True)
    contract_freq_code = Column(String, nullable=True)
    contract_duration = Column(String, nullable=True)

    user_id = Column(Integer, ForeignKey("users.id"))
    owner = relationship("User", back_populates="employment_data" )


