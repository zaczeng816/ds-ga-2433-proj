#Create Database in AWS Instance#

from sqlalchemy import create_engine, text
from sqlalchemy.orm import declarative_base

DATABASE_URL = "mysql+pymysql://admin:pass123456@dms-final-24-instance-1.c9qk2w2o6mml.us-east-1.rds.amazonaws.com:3306"

engine = create_engine(DATABASE_URL)
Base = declarative_base()


if __name__ == "__main__":
    try:
        connection = engine.connect()
        print("Database connected successfully!")

        connection.execute(text("CREATE DATABASE IF NOT EXISTS medicalData;"))
        print("Database 'medicalData' created successfully!")
        connection.close()


    except Exception as e:
        print(f"An error occurred: {e}")
