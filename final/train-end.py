from flask import Flask, request, jsonify
import pandas as pd
import xgboost as xgb
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
import numpy as np
import json
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, String
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

DATABASE_URL = "mysql+pymysql://admin:pass123456@dms-final-24-instance-1.c9qk2w2o6mml.us-east-1.rds.amazonaws.com:3306/medicalData"

engine = create_engine(DATABASE_URL)
Base = declarative_base()
Session = sessionmaker(bind=engine)
session = Session()


model = None
features = []

class UserLogin(Base):
    __tablename__ = 'user_login'

    CID = Column(String(15), primary_key=True)
    Username = Column(String(50), nullable=False, unique=True)
    Password = Column(String(50), nullable=False)


@app.route('/login', methods=['POST'])
def match_password():
    try:
        data = request.json
        username = data.get("username")
        password = data.get("password")

        if not username or not password:
            return jsonify({"error": "Username and password are required."}), 400

        user = session.query(UserLogin).filter_by(Username=username).first()

        if user and user.Password == password:
            return jsonify({"message": "Login successful!", "CID": user.CID}), 200
        else:
            return jsonify({"error": "Invalid username or password."}), 401

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/train', methods=['POST'])
def train_model():
    global model, features
    try:
        file = request.files['file']
        data = pd.read_json(file)

        features = [
            'healthCheckup_vitalSigns_bmi',
            'healthCheckup_vitalSigns_bloodPressure_systolic',
            'healthCheckup_vitalSigns_bloodPressure_diastolic',
            'healthCheckup_vitalSigns_pulseRate',
            'healthCheckup_vitalSigns_temperature'
        ]

        data['has_hypertension'] = data['medicalVisit_diagnosis_primary'].apply(
            lambda x: 1 if 'Hypertension' in str(x) else 0
        )
        features.append('has_hypertension')

        X = data[features]
        y = data['monthly_premium']

        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        model = xgb.XGBRegressor(
            objective='reg:squarederror',
            n_estimators=100,
            learning_rate=0.1,
            max_depth=6,
            random_state=42
        )

        model.fit(X_train, y_train)

        y_pred = model.predict(X_test)

        mse = mean_squared_error(y_test, y_pred)
        rmse = np.sqrt(mse)
        r2 = r2_score(y_test, y_pred)

        return jsonify({
            "message": "Model trained successfully!",
            "rmse": rmse,
            "r2": r2
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/predict', methods=['POST'])
def predict():
    global model, features
    try:
        if model is None:
            return jsonify({"error": "Model is not trained yet."}), 400

        input_data = request.json
        input_df = pd.DataFrame([input_data])

        for feature in features:
            if feature not in input_df.columns:
                input_df[feature] = 0

        prediction = model.predict(input_df[features])[0]

        return jsonify({"prediction": prediction})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == '__main__':
    app.run(debug=True)
