from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from uuid import UUID, uuid4
from enum import Enum
from typing import List
import random

app = FastAPI()

class PaymentStatus(str, Enum):
    success = "success"
    failed = "failed"

class Product(BaseModel):
    id: UUID = Field(default_factory=uuid4)
    name: str
    price: float
    currency: str = "USD"

class CardData(BaseModel):
    card_number: str = Field(min_length=16, max_length=16)
    card_holder: str
    expiry_month: int = Field(ge=1, le=12)
    expiry_year: int = Field(ge=2024)
    cvv: str = Field(min_length=3, max_length=3)

class Payment(BaseModel):
    id: UUID = Field(default_factory=uuid4)
    product_id: UUID
    amount: float
    status: PaymentStatus

products: List[Product] = []
payments: List[Payment] = []

def process_payment_mock(card: CardData) -> PaymentStatus:
    return PaymentStatus.success if random.random() < 0.8 else PaymentStatus.failed

@app.post("/products", response_model=Product)
def add_product(product: Product):
    products.append(product)
    return product

@app.post("/pay/{product_id}", response_model=Payment)
def pay_for_product(product_id: UUID, card: CardData):
    product = next((p for p in products if p.id == product_id), None)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    status = process_payment_mock(card)

    payment = Payment(
        product_id=product.id,
        amount=product.price,
        status=status
    )
    payments.append(payment)
    return payment

@app.get("/products/purchased")
def purchased_products():
    paid_ids = {p.product_id for p in payments if p.status == PaymentStatus.success}
    return [p for p in products if p.id in paid_ids]
