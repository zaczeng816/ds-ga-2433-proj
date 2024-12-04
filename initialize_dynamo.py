import boto3
from botocore.exceptions import ClientError
from decimal import Decimal

def create_medical_records_table():
    dynamodb = boto3.client('dynamodb')
    
    try:
        response = dynamodb.create_table(
            TableName='MedicalRecords',
            AttributeDefinitions=[
                {'AttributeName': 'documentId', 'AttributeType': 'S'},
                {'AttributeName': 'customerId', 'AttributeType': 'S'},
                {'AttributeName': 'type', 'AttributeType': 'S'},
                {'AttributeName': 'date', 'AttributeType': 'S'}  # For both date and visitDate
            ],
            KeySchema=[
                {'AttributeName': 'documentId', 'KeyType': 'HASH'},
                {'AttributeName': 'customerId', 'KeyType': 'RANGE'}
            ],
            GlobalSecondaryIndexes=[
                {
                    'IndexName': 'CustomerTypeIndex',
                    'KeySchema': [
                        {'AttributeName': 'customerId', 'KeyType': 'HASH'},
                        {'AttributeName': 'type', 'KeyType': 'RANGE'}
                    ],
                    'Projection': {'ProjectionType': 'ALL'},
                    'ProvisionedThroughput': {
                        'ReadCapacityUnits': 5,
                        'WriteCapacityUnits': 5
                    }
                },
                {
                    'IndexName': 'TypeDateIndex',
                    'KeySchema': [
                        {'AttributeName': 'type', 'KeyType': 'HASH'},
                        {'AttributeName': 'date', 'KeyType': 'RANGE'}
                    ],
                    'Projection': {'ProjectionType': 'ALL'},
                    'ProvisionedThroughput': {
                        'ReadCapacityUnits': 5,
                        'WriteCapacityUnits': 5
                    }
                }
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 5,
                'WriteCapacityUnits': 5
            }
        )
        print("Table created successfully")
        return response
    except ClientError as e:
        if e.response['Error']['Code'] == 'ResourceInUseException':
            print("Table already exists")
        else:
            raise e

def insert_sample_records():
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('MedicalRecords')
    
    # Health Checkup Record
    health_checkup = {
        'documentId': 'HC-2024-001',
        'customerId': 'CID-12345',
        'type': 'healthCheckup',
        'date': '2024-01-15',
        'vitalSigns': {
            'bloodPressure': {
                'systolic': 120,
                'diastolic': 80
            },
            'pulseRate': 72,
            'temperature': Decimal('98.6'),
            'bmi': Decimal('24.5')
        },
        'examFindings': {
            'general': 'Patient appears healthy and well-nourished',
            'cardiovascular': 'Regular rate and rhythm, no murmurs',
            'respiratory': 'Clear to auscultation bilaterally',
            'musculoskeletal': 'Full range of motion, no abnormalities'
        },
        'recommendations': 'Continue current health maintenance, follow up in 1 year',
        'examiningPhysician': {
            'name': 'Dr. Sarah Smith',
            'id': 'PHY-789'
        }
    }
    
    # Medical Visit Record
    medical_visit = {
        'documentId': 'MV-2024-001',
        'customerId': 'CID-12345',
        'type': 'medicalVisit',
        'date': '2024-01-20',
        'claimNumber': 'CLM-2024-0123',
        'facility': {
            'name': 'City Medical Center',
            'id': 'FAC-456',
            'type': 'outpatient'
        },
        'provider': {
            'name': 'Dr. John Lee',
            'id': 'PHY-456',
            'specialty': 'Internal Medicine'
        },
        'diagnosis': {
            'primary': 'Acute bronchitis',
            'secondary': ['Seasonal allergies']
        },
        'treatment': {
            'procedures': ['Chest examination', 'Spirometry'],
            'medications': ['Azithromycin 250mg', 'Albuterol inhaler'],
            'instructions': 'Rest, increase fluid intake, use inhaler as needed'
        },
        'followUp': {
            'required': True,
            'date': '2024-02-03',
            'notes': 'Return if symptoms worsen'
        }
    }
    
    # Lab Report Record
    lab_report = {
        'documentId': 'LR-2024-001',
        'customerId': 'CID-12345',
        'type': 'labReport',
        'date': '2024-01-20',
        'reportDate': '2024-01-22',
        'orderedBy': {
            'name': 'Dr. John Lee',
            'id': 'PHY-456'
        },
        'facility': {
            'name': 'City Lab Services',
            'id': 'LAB-789'
        },
        'testCategory': 'Complete Blood Count',
        'results': [
            {
                'testName': 'WBC',
                'value': '7.5',
                'unit': 'K/uL',
                'referenceRange': '4.5-11.0',
                'interpretation': 'Normal',
                'flags': []
            },
            {
                'testName': 'Hemoglobin',
                'value': '14.2',
                'unit': 'g/dL',
                'referenceRange': '13.5-17.5',
                'interpretation': 'Normal',
                'flags': []
            }
        ],
        'notes': 'All results within normal ranges'
    }

    # Insert records
    for record in [health_checkup, medical_visit, lab_report]:
        try:
            table.put_item(Item=record)
            print(f"Successfully inserted {record['documentId']}")
        except Exception as e:
            print(f"Error inserting {record['documentId']}: {str(e)}")

if __name__ == '__main__':
    # create_medical_records_table()
    insert_sample_records()
