from fastapi import FastAPI

app = FastAPI(title="hybrid-app backend", version="0.1.0")


@app.get("/health")
async def health() -> dict:
    return {"status": "ok", "service": "hybrid-app-backend"}


@app.get("/")
async def root() -> dict:
    return {"message": "Hello from unified-reference-stack / hybrid-app backend"}
