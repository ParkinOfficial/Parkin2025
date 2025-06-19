from typing import List
from models.models import *
from main import *
from pydantic import BaseModel,create_model


user_column_names=[column.name for column in User.__table__.columns if column.name != 'user_id']


def create_student_model(column_names: List[str]):
    fields = {name: (str, ...) for name in column_names }
    return create_model('UserModel', **fields)

UserModel = create_student_model(user_column_names)

