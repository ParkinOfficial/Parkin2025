from typing import List
from pydantic import create_model
from models.models import model_registry

Parklot = None

def get_parklot_column_names() -> List[str]:
    global Parklot
    Parklot = model_registry["parklot"]
    return [
        column.name for column in Parklot.__table__.columns
        if column.name not in ["parklot_id"]  # Exclude PK
    ]

def create_parklot_model(column_names: List[str]):
    fields = {}
    for name in column_names:
        fields[name] = (str, ...)  # All fields as string for now (e.g. name, slot_id)
    return create_model("ParklotModel", **fields)
