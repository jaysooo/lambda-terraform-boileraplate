
import json

def lambda_handler(event, context):
    print('event : ',event)
    print('context : ',context)
    
    return {
        'statusCode': 200,
        'message' : 'test function..'
    }