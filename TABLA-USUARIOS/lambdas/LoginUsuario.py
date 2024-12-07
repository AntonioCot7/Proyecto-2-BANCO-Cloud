import boto3
import uuid
from datetime import datetime, timedelta
import json
import os

def lambda_handler(event, context):
    if 'body' in event:
        if isinstance(event['body'], str):
            try:
                body = json.loads(event['body'])
            except json.JSONDecodeError:
                return {
                    'statusCode': 400,
                    'body': {
                        'message': 'Error en el formato del JSON enviado.'
                    }
                }
        else:
            body = event['body']
    else:
        body = event

    email = body.get('email')
    password = body.get('password')

    if not email or not password:
        return {
            'statusCode': 400,
            'body': {
                'message': 'Faltan los campos requeridos: email y/o password.'
            }
        }

    dynamodb = boto3.resource('dynamodb')
    usuarios_table = dynamodb.Table(os.environ.get('USUARIOS_TABLE'))

    response = usuarios_table.scan(
        FilterExpression="email = :email_val",
        ExpressionAttributeValues={":email_val": email}
    )
    items = response.get('Items')

    if not items:
        return {
            'statusCode': 403,
            'body': {
                'message': 'Usuario no existe'
            }
        }

    user = items[0]
    if password != user['password']:  # Comparación de contraseña en texto plano
        return {
            'statusCode': 403,
            'body': {
                'message': 'Contraseña incorrecta'
            }
        }

    token = str(uuid.uuid4())
    expires = (datetime.now() + timedelta(minutes=60)).strftime('%Y-%m-%d %H:%M:%S')

    tokens_table = dynamodb.Table(os.environ.get('TOKENS_TABLE'))
    tokens_table.put_item(
        Item={
            'token': token,
            'expires': expires,
            'usuario_id': user['usuario_id']
        }
    )
    
    return {
        'statusCode': 200,
        'body': {
            'message': 'Inicio de sesión exitoso',
            'token': token,
            'expires': expires,
            'usuario_id': user['usuario_id']
        }
    }
