from typing import List
from pydantic import create_model
from sqlalchemy.orm import DeclarativeBase, relationship
from sqlalchemy import Table, Column, Integer, ForeignKey
from database.database import engine
from sqlalchemy import Table
from sqlalchemy.ext.asyncio import AsyncEngine
from sqlalchemy import Table, MetaData
import sys
from schemas.common_schema import create_login_model,get_common_column_names

model_registry = {}
metadata = MetaData()

User = Slot = Booking = Rental = ParkLot = Image = Common = LoginModel = None

class Base(DeclarativeBase):
    pass

async def reflect_models(engine: AsyncEngine, table_names: list[str]):
    async with engine.begin() as conn:
        def do_reflection(sync_conn):
            for name in table_names:
                table = Table(name, Base.metadata, autoload_with=sync_conn)
                model_class = type(name.capitalize(), (Base,), {"__table__": table})
                model_registry[name] = model_class
        await conn.run_sync(do_reflection)

def set_globals():
    global User, Slot, Booking, Rental, ParkLot, Image, Common
    User = model_registry["user"]
    Slot = model_registry["slot"]
    Booking = model_registry["booking"]
    Rental = model_registry["rental"]
    ParkLot = model_registry["parklot"]
    Image = model_registry["image"]
    Common = model_registry["common"]
