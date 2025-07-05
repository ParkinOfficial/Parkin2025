from typing import Union, Literal
from pydantic import BaseModel, Field
from schemas.rental_schema import *
from schemas.parklot_schema import *
from schemas.user_schema import *
from schemas.slot_schemas import *

# Dynamically create models
UserModel = create_user_model(get_user_column_names())
RentalModel = create_rental_model(get_rental_column_names())
ParklotModel = create_parklot_model(get_parklot_column_names())
SlotModel = create_slot_model(get_slot_column_names())

# Wrap rental and parklot with slot
class RentalWrapper(BaseModel):
    slot: SlotModel
    rental: RentalModel

class ParklotWrapper(BaseModel):
    slot: SlotModel
    parklot: ParklotModel

# Master register request
class RegisterRequest(BaseModel):
    role: Literal["user", "rental", "parklot"]
    data: Union[UserModel, RentalWrapper, ParklotWrapper]
