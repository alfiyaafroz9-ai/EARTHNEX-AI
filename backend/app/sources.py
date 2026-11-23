import httpx
from .config import LOCATION_NAME, LATITUDE, LONGITUDE

async def fetch_live_weather():
    url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": LATITUDE, "longitude": LONGITUDE,
        "current": "temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m",
        "hourly": "temperature_2m,relative_humidity_2m,precipitation_probability,precipitation",
        "daily": "temperature_2m_max,temperature_2m_min,precipitation_sum",
        "forecast_days": 7, "timezone": "auto"
    }
    async with httpx.AsyncClient(timeout=20) as client:
        response = await client.get(url, params=params)
        response.raise_for_status()
        data = response.json()
    return {
        "location": LOCATION_NAME, "latitude": LATITUDE, "longitude": LONGITUDE,
        "provider": "Open-Meteo", "current": data.get("current", {}),
        "hourly": data.get("hourly", {}), "daily": data.get("daily", {}),
        "fetched_at": data.get("current", {}).get("time"),
        "data_note": "Weather model/API data; not a physical sensor reading."
    }
