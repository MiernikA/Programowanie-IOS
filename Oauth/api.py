
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uuid

app = FastAPI()

class RegisterRequest(BaseModel):
    email: str
    password: str

class LoginRequest(BaseModel):
    email: str
    password: str

class AuthResponse(BaseModel):
    token: str

users = []

def generate_token() -> str:
    return str(uuid.uuid4())

@app.post("/auth/register")
def register(data: RegisterRequest):
    for user in users:
        if user["email"] == data.email:
            raise HTTPException(status_code=400, detail="User already exists")

    users.append({
        "id": len(users) + 1,
        "email": data.email,
        "password": data.password
    })

    return { "status": "registered" }

@app.post("/auth/login", response_model=AuthResponse)
def login(data: LoginRequest):
    for user in users:
        if user["email"] == data.email and user["password"] == data.password:
            return { "token": generate_token() }

    raise HTTPException(status_code=401, detail="Invalid credentials")
