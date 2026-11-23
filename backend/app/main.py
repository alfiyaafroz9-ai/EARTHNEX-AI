from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from .config import LOCATION_NAME, LATITUDE, LONGITUDE
from .sources import fetch_live_weather
from .database import initialize_database, save_weather, database_enabled

app = FastAPI(title="EARTHNEX AI API",
              description="Integrated Earth System Intelligence — PostGIS-free starter",
              version="1.0.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=False,
                   allow_methods=["*"], allow_headers=["*"])

@app.on_event("startup")
def startup():
    try:
        initialize_database()
    except Exception as exc:
        print(f"PostgreSQL initialization warning: {exc}")

@app.get("/")
def home():
    return {"application": "EARTHNEX AI", "status": "running", "version": "1.0.0",
            "database": "PostgreSQL" if database_enabled else "disabled",
            "postgis": "not used", "location": LOCATION_NAME}

@app.get("/health")
def health():
    return {"status": "healthy", "backend": "online"}

@app.get("/api/location")
def location():
    return {"name": LOCATION_NAME, "latitude": LATITUDE, "longitude": LONGITUDE}

@app.get("/api/live/weather")
async def live_weather():
    try:
        payload = await fetch_live_weather()
        try:
            payload["saved_to_postgresql"] = save_weather(payload)
        except Exception as exc:
            payload["saved_to_postgresql"] = False
            payload["database_warning"] = str(exc)
        return payload
    except Exception as exc:
        raise HTTPException(status_code=502, detail=f"Weather source unavailable: {exc}")

MODULES = [
    ("earth_map", "Earth Map", "Interactive geospatial layers", "planned"),
    ("climate", "Climate Intelligence", "Current weather, forecast and historical climate", "partial"),
    ("land", "Land Intelligence", "Land cover and land-use change", "planned"),
    ("vegetation", "Vegetation Intelligence", "NDVI and vegetation health", "planned"),
    ("water", "Water Intelligence", "Water bodies and water quality", "planned"),
    ("rivers", "River Intelligence", "River networks, sediment and water quality", "planned"),
    ("oceans", "Ocean Intelligence", "Sea-surface and coastal indicators", "planned"),
    ("pollution", "Pollution Intelligence", "Air pollutants and potential pathways", "planned"),
    ("geology", "Geological Intelligence", "Verified mineral occurrence mapping", "planned"),
    ("predictions", "Predictive Intelligence", "Trend models and forecasts", "planned")
]

@app.get("/api/modules")
def modules():
    return {"modules": [{"id": i, "name": n, "description": d, "status": s}
                        for i, n, d, s in MODULES]}

@app.get("/api/pipeline")
def pipeline():
    names = ["Data Collection", "Data Validation", "Data Processing", "Data Storage",
             "Trend Detection", "Cross-System Analysis", "Prediction", "Visualization & Reports"]
    return {"stages": [{"id": i + 1, "name": n,
             "status": "completed" if i in (0, 1, 2, 7) else
                       ("partial" if i == 3 and database_enabled else "planned")}
             for i, n in enumerate(names)]}

@app.get("/api/climate/forecast")
async def climate_forecast():
    try:
        d = await fetch_live_weather()
        return {"location": d["location"], "daily": d["daily"],
                "provider": d["provider"], "note": d["data_note"]}
    except Exception as exc:
        raise HTTPException(status_code=502, detail=str(exc))

@app.get("/api/trends")
def trends(variable: str = "temperature", period: str = "historical"):
    return {"variable": variable, "period": period, "status": "dataset_required",
            "message": "Connect a quality-controlled historical dataset before calculating a real trend.",
            "metrics": None, "observations": []}

@app.get("/api/rivers")
def rivers():
    return {"status": "dataset_required",
            "message": "River flow, chemistry and sediment datasets are not connected yet.",
            "records": []}

@app.get("/api/geology/minerals")
def minerals():
    return {"status": "dataset_required",
            "message": "Only verified geological survey/mineral occurrence records should be displayed.",
            "records": []}

class AgentRequest(BaseModel):
    message: str = Field(min_length=1, max_length=2000)
@app.post("/api/agent/chat")
async def agent_chat(request: AgentRequest):
    msg = request.message.strip()
    if not msg:
        raise HTTPException(status_code=400, detail="Message cannot be empty")
    low = msg.lower()
    if any(k in low for k in ("weather", "temperature", "humidity", "rain", "मौसम", "तापमान")):
        try:
            w = await fetch_live_weather()
            c = w.get("current", {})
            answer = (f"{w['location']}: temperature {c.get('temperature_2m')} °C, "
                      f"humidity {c.get('relative_humidity_2m')}%, wind {c.get('wind_speed_10m')} km/h. "
                      "This is weather model data, not a sensor reading.")
            context = c
        except Exception as exc:
            answer, context = f"Live weather unavailable: {exc}", {}
    else:
        answer = ("I am the EARTHNEX AI assistant. I can explain connected climate data and platform modules. "
                  "Historical trends, pollution pathways, river chemistry and mineral prospectivity require "
                  "validated datasets and models before scientific claims can be made.")
        context = {}
    return {"agent": "EARTHNEX AI", "mode": "grounded-starter",
            "answer": answer, "context": context}
           