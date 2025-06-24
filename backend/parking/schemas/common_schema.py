from typing import List
from pydantic import create_model
from models.models import model_registry
Common =  None
def get_common_column_names() -> List[str]:
    global Common
    Common = model_registry['common']
    return [
        column.name for column in Common.__table__.columns
        if column.name not in ['login_id', 'otp', 'access_token','roles']
    ]

def create_login_model(column_names: List[str]):
    fields = {name: (str, ...) for name in column_names}
    return create_model('LoginModel', **fields)


