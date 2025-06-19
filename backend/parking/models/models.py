from typing import List
from pydantic import create_model
from sqlalchemy.orm import DeclarativeBase, relationship
from sqlalchemy import Table, Column, Integer, ForeignKey
from database.database import engine


class Base(DeclarativeBase):
    pass


class Common(Base):
    __table__ = Table('common', Base.metadata, autoload_with=engine)

class User(Base):
    __table__ = Table('user', Base.metadata, autoload_with=engine)
  
class Rental(Base):
    __table__ = Table('rental', Base.metadata, autoload_with=engine)

class Parklot(Base):
    __table__ = Table('parklot', Base.metadata, autoload_with=engine)

class Slot(Base):
    __table__ = Table('slot', Base.metadata, autoload_with=engine)

class Image(Base):
    __table__ = Table('image', Base.metadata, autoload_with=engine)

class Booking(Base):
    __table__ = Table('booking', Base.metadata, autoload_with=engine)