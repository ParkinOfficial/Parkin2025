from typing import List
from pydantic import create_model
from sqlalchemy.orm import DeclarativeBase, relationship
from sqlalchemy import Table, Column, Integer, ForeignKey
from database.database import engine
from sqlalchemy import Table
from sqlalchemy.ext.asyncio import AsyncEngine
from sqlalchemy import Table, MetaData

model_registry = {}
metadata = MetaData()

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


