# backend/app.py
from fastapi import FastAPI
from services import image_gen, tts, nlp
from database import database

app = FastAPI()

@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

@app.get("/")
def read_root():
    return {"message": "Welcome to VisuaLit Backend"}

@app.post("/generate-image/")
def generate_image(text: str):
    return image_gen.generate_image(text)

@app.post("/text-to-speech/")
def text_to_speech(text: str):
    return tts.convert_text_to_speech(text)

@app.post("/nlp/")
def nlp_interaction(text: str):
    return nlp.process_text(text)