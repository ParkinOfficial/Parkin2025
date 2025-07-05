import uuid
from sqlalchemy import insert
from sqlalchemy.ext.asyncio import AsyncSession
from models.models import model_registry

async def insert_slot(db: AsyncSession, slot_data: dict) -> str:
    Slot = model_registry['slot']
    slot_id = str(uuid.uuid4())
    stmt = insert(Slot).values(slot_id=slot_id, **slot_data)
    await db.execute(stmt)
    return slot_id

async def insert_user(db: AsyncSession, data: dict) -> str:
    Users = model_registry['users']
    user_id = str(uuid.uuid4())
    stmt = insert(Users).values(user_id=user_id, **data)
    await db.execute(stmt)
    return user_id

async def insert_rental(db: AsyncSession, data: dict, slot_id: str) -> str:
    Rental = model_registry['rental']
    rental_id = str(uuid.uuid4())
    stmt = insert(Rental).values(rental_id=rental_id, name=data["name"], slot_id=slot_id)
    await db.execute(stmt)
    return rental_id

async def insert_parklot(db: AsyncSession, data: dict, slot_id: str) -> str:
    Parklot = model_registry['parklot']
    parklot_id = str(uuid.uuid4())
    stmt = insert(Parklot).values(parklot_id=parklot_id, name=data["name"], slot_id=slot_id)
    await db.execute(stmt)
    return parklot_id

async def insert_common(db: AsyncSession, mobile_number: int, phone_code: str, role_data: dict):
    Common = model_registry['common']
    login_id = str(uuid.uuid4())
    stmt = insert(Common).values(
        login_id=login_id,
        mobile_number=mobile_number,
        phone_code=phone_code,
        roles=role_data
    )
    await db.execute(stmt)
    return login_id
