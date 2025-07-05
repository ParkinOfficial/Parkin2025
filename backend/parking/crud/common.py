from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
import json

async def get_common_record(db: AsyncSession, Common, number: int, phone_code: str):
    stmt = select(Common).where(
        Common.mobile_number == number,
        Common.phone_code == phone_code
    )
    result = await db.execute(stmt)
    return result.scalar_one_or_none()

async def get_linked_ids(db: AsyncSession, number: int, model_registry: dict):
    ids = {}

    for table_name in ['users', 'rental', 'parklot']:
        model = model_registry.get(table_name)
        if not model:
            continue

        # ORM access
        stmt = select(model).where(model.mobile_number == number)
        result = await db.execute(stmt)
        record = result.scalar_one_or_none()

        if record:
            # ✅ Get primary key column name from ORM model
            primary_key_column = model.__mapper__.primary_key[0].name
            ids[f"{table_name}_id"] = getattr(record, primary_key_column)

    return ids

