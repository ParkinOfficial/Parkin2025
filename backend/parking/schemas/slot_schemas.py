from typing import List
from pydantic import create_model
from models.models import model_registry

Slot = None

def get_slot_column_names() -> List[str]:
    global Slot
    Slot = model_registry["slot"]
    return [
        column.name for column in Slot.__table__.columns
        if column.name not in ["slot_id"]  # Exclude auto-generated PK
    ]

def create_slot_model(column_names: List[str]):
    fields = {}
    for name in column_names:
        # Customize field types based on known JSON fields
        if name in ["vehicle_type", "vehicle_rate", "location", "facilities", "slot_image", "slots"]:
            fields[name] = (dict, ...)
        else:
            fields[name] = (str, ...)  # Default to string
    return create_model("SlotModel", **fields)
