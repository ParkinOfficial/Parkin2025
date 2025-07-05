from typing import List
from pydantic import create_model
from models.models import model_registry

Rental = None

def get_rental_column_names() -> List[str]:
    global Rental
    Rental = model_registry["rental"]
    return [
        column.name for column in Rental.__table__.columns
        if column.name not in ["rental_id"]  # Exclude PK
    ]

def create_rental_model(column_names: List[str]):
    fields = {}
    for name in column_names:
        fields[name] = (str, ...)  # All fields as string for now (e.g. name, slot_id)
    return create_model("RentalModel", **fields)
