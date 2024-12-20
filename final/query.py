from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, String

DATABASE_URL = "mysql+pymysql://admin:pass123456@dms-final-24-instance-1.c9qk2w2o6mml.us-east-1.rds.amazonaws.com:3306/medicalData"

engine = create_engine(DATABASE_URL)
Base = declarative_base()
Session = sessionmaker(bind=engine)
session = Session()

class UserLogin(Base):
    __tablename__ = 'user_login'

    CID = Column(String(15), primary_key=True)
    Username = Column(String(50), nullable=False, unique=True)
    Password = Column(String(50), nullable=False)

if __name__ == "__main__":
    try:
        username_to_query = "NY2002"
        user = session.query(UserLogin).filter_by(Username=username_to_query).first()

        if user:
            print(f"Password for username '{username_to_query}': {user.Password}")
        else:
            print(f"Username '{username_to_query}' not found in the database.")

    except Exception as e:
        print(f"An error occurred: {e}")

    finally:
        session.close()
