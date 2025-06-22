from typing import List
from pydantic import create_model
from models.models import Common  

def get_common_column_names() -> List[str]:
    print(Common)
    return [
        column.name for column in Common.__table__.columns
        if column.name not in ['login_id', 'otp', 'access_token']
    ]

def create_login_model(column_names: List[str]):
    fields = {name: (str, ...) for name in column_names}
    return create_model('LoginModel', **fields)

LoginModel = create_login_model(get_common_column_names())

