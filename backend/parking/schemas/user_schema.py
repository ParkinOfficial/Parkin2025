from typing import List
from pydantic import create_model
from models.models import model_registry

Users = None

def get_user_column_names() -> List[str]:
    global Users
    Users = model_registry["users"]
    return [
        column.name for column in Users.__table__.columns
        if column.name not in ["user_id"]  # Exclude auto-generated PK
    ]

def create_user_model(column_names: List[str]):
    fields = {}
    for name in column_names:
        if name == "mobile_number":
            fields[name] = (int, ...)
        else:
            fields[name] = (str, ...)  # Default to string
    return create_model("UserModel", **fields)
