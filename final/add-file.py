from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime
from sqlalchemy.orm import declarative_base, sessionmaker
from datetime import datetime, timedelta
import random
import string

DATABASE_URL = "mysql+pymysql://admin:pass123456@dms-final-24-instance-1.c9qk2w2o6mml.us-east-1.rds.amazonaws.com:3306/medicalData"

engine = create_engine(DATABASE_URL)
Base = declarative_base()
Session = sessionmaker(bind=engine)
session = Session()

class CustomerData(Base):
    __tablename__ = 'customer_data'

    CID = Column(String(15), primary_key=True)
    CLast = Column(String(50), nullable=False)
    CFirst = Column(String(50), nullable=False)
    CMiddle = Column(String(50), nullable=True)
    CSuffix = Column(String(10), nullable=True)
    CDOB = Column(DateTime, nullable=False)
    CSalutation = Column(String(10), nullable=True)
    CEmailAddress = Column(String(100), nullable=False, unique=True)
    Gender = Column(String(1), nullable=False)
    SSN_TIN = Column(String(9), nullable=False, unique=True)
    SSNType = Column(String(10), nullable=True)
    PreferredLanguage = Column(String(20), nullable=True)
    StartDate = Column(DateTime, nullable=False)
    EndDate = Column(DateTime, nullable=True)
    CreatedAt = Column(DateTime, default=datetime.now, nullable=False)
    UpdatedAt = Column(DateTime, default=datetime.now, onupdate=datetime.now, nullable=False)

class UserLogin(Base):
    __tablename__ = 'user_login'

    CID = Column(String(15), primary_key=True)
    Username = Column(String(50), nullable=False, unique=True)
    Password = Column(String(50), nullable=False)

def random_string(length):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def random_date(start, end):
    return start + timedelta(days=random.randint(0, (end - start).days))

if __name__ == "__main__":
    try:
        Base.metadata.drop_all(engine)
        print("Tables dropped successfully!")

        Base.metadata.create_all(engine)
        print("Tables created successfully!")

        data = []
        login_data = []
        dob_start_date = datetime(1950, 1, 1)
        dob_end_date = datetime(2003, 1, 1)

        for i in range(1, 1001):
            cid = f"{i:015}"
            clast = random_string(random.randint(3, 10)).capitalize()
            cfirst = random_string(random.randint(3, 10)).capitalize()
            cmiddle = random_string(random.randint(3, 10)).capitalize() if random.random() > 0.5 else None
            csuffix = random.choice(['Jr.', 'Sr.', 'III', None])
            cdob = random_date(dob_start_date, dob_end_date)
            csalutation = random.choice(['Mr.', 'Ms.', 'Dr.', None])
            cemailaddress = f"{cfirst.lower()}.{clast.lower()}@example.com"
            gender = random.choice(['M', 'F', 'U'])
            ssn_tin = ''.join(random.choices(string.digits, k=9))
            ssn_type = random.choice(['SSN', 'TIN', None])
            preferred_language = random.choice(['English', 'Spanish', 'French', 'German', 'Chinese', None])
            start_date = random_date(datetime(2000, 1, 1), datetime(2023, 1, 1))
            end_date = start_date + timedelta(days=random.randint(30, 1000)) if random.random() > 0.5 else None
            created_at = datetime.now()
            updated_at = datetime.now()

            data.append(CustomerData(
                CID=cid,
                CLast=clast,
                CFirst=cfirst,
                CMiddle=cmiddle,
                CSuffix=csuffix,
                CDOB=cdob,
                CSalutation=csalutation,
                CEmailAddress=cemailaddress,
                Gender=gender,
                SSN_TIN=ssn_tin,
                SSNType=ssn_type,
                PreferredLanguage=preferred_language,
                StartDate=start_date,
                EndDate=end_date,
                CreatedAt=created_at,
                UpdatedAt=updated_at
            ))

            if i == 1:
                username = "NY2002"
                password = "123456"
            else:
                username = random_string(8)
                password = random_string(10)

            login_data.append(UserLogin(
                CID=cid,
                Username=username,
                Password=password
            ))

        session.bulk_save_objects(data)
        session.bulk_save_objects(login_data)
        session.commit()
        print("Inserted 1000 rows into 'customer_data' and 'user_login' tables successfully!")

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        session.close()
