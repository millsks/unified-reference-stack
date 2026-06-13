from fastapi import FastAPI

app = FastAPI(title="py-service", version="0.1.0")


@app.get("/health")
async def health() -> dict:
    return {"status": "ok", "service": "py-service"}


@app.get("/")
async def root() -> dict:
    return {"message": "Hello from unified-reference-stack / py-service"}
