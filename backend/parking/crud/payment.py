import razorpay
from fastapi import APIRouter
from pydantic import BaseModel
import os

router = APIRouter()


client = razorpay.Client(auth=("rzp_test_TXha1iNsfNWYWy", "0Y3UEedEUCUWYUYgsVDzApYd"))

class OrderRequest(BaseModel):
    amount: int  # in rupees

@router.post("/create-order")
def create_order(order: OrderRequest):
    payment = client.order.create({
        "amount": order.amount * 100,  # convert to paise
        "currency": "INR",
        "payment_capture": 1
    })
    return payment