from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

app = FastAPI()


class Category(BaseModel):
    id: int
    name: str


class Product(BaseModel):
    id: int
    name: str
    price: float
    categoryId: int


class Order(BaseModel):
    id: int
    status: str
    totalPrice: float
    productIds: List[int]


categories = [
    Category(id=1, name="Food"),
    Category(id=2, name="Electronics")
]

products = [
    Product(id=1, name="Milk", price=3.99, categoryId=1),
    Product(id=2, name="Bread", price=2.49, categoryId=1),
    Product(id=3, name="Laptop", price=3999.0, categoryId=2)
]

orders = [
    Order(id=1, status="CREATED", totalPrice=6.48, productIds=[1, 2]),
    Order(id=2, status="PAID", totalPrice=3999.0, productIds=[3])
]


@app.get("/categories")
def get_categories():
    return categories


@app.get("/products")
def get_products():
    return products


@app.get("/orders")
def get_orders():
    return orders


@app.post("/products")
def add_product(product: Product):
    products.append(product)
    return product


