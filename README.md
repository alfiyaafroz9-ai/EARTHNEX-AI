# EARTHNEX AI — Integrated Earth System Intelligence Platform

This ZIP is a runnable modular starter, not a claim that every scientific module is already fully operational.

## Included
- Flutter dark dashboard with 12 navigation areas.
- FastAPI backend and Swagger documentation.
- Open-Meteo current weather and 7-day forecast.
- Optional PostgreSQL persistence using numeric latitude/longitude.
- No PostGIS.
- Clearly labelled endpoints for historical trends, rivers and mineral occurrences. These require verified datasets before scientific values can be shown.

## Backend (PowerShell)
```powershell
cd backend
py -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
uvicorn app.main:app --reload
```
Swagger: http://127.0.0.1:8000/docs

PostgreSQL is optional. Set DATABASE_URL in backend/.env after creating a PostgreSQL database. No PostGIS extension is needed.

## Flutter
```powershell
cd frontend
flutter pub get
flutter run -d chrome
```
Default API URL is http://127.0.0.1:8000 in frontend/lib/main.dart.

For a phone, replace 127.0.0.1 with your computer's LAN IP.

## Data integrity
Historical climate, NDVI, air pollution, river chemistry, ocean observations, verified mineral occurrences and predictive models need authoritative data sources and validation. The starter does not fabricate those measurements. Weather forecasts are not long-term climate projections.
