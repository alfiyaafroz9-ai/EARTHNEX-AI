# EARTHNEX AI
### Integrated Earth System Intelligence & Predictive Analytics Platform

**Team Name:** EARTHNEX AI

## 1. Overview
EARTHNEX AI is an integrated Earth-system intelligence platform designed to bring environmental and Earth observation information together for easier exploration, monitoring and analysis.

It aims to connect information related to land, oceans, water bodies, climate, soil and geological resources through a unified interface.

## 2. Problem Statement
Earth observation datasets are distributed across multiple platforms, formats and scientific domains. This fragmentation makes it difficult to explore interconnected environmental conditions and identify meaningful patterns.

## 3. Proposed Solution
EARTHNEX AI provides a unified platform to explore environmental datasets, visualize relevant information and support data-driven understanding of Earth systems.

## 4. Key Features
- Integrated Earth-system data exploration
- Environmental dataset access and organization
- Interactive user interface
- Backend API for data processing and integration
- Geographic and environmental information visualization
- Predictive analytics capabilities (where implemented)

## 5. Technology Stack
- Frontend: Flutter / Dart
- Backend: Python / FastAPI
- Data processing: Python
- Data sources: NASA Earth science datasets and relevant public environmental sources

## 6. Project Structure

```text
EARTHNEX_AI/
├── backend/
│   ├── app/
│   │   ├── config.py
│   │   ├── database.py
│   │   ├── main.py
│   │   └── sources.py
│   ├── requirements.txt
│   └── .env.example
├── frontend/
│   ├── lib/
│   │   └── main.dart
│   └── pubspec.yaml
└── README.md
```

## 7. Running the Project

### Backend
```bash
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Frontend
```bash
cd frontend
flutter pub get
flutter run -d chrome
```

Check the backend configuration and API URL before running the frontend.

## 8. Data Sources
NASA Earthdata and relevant NASA open-data services are intended data sources. Refer to the actual integrated endpoints and dataset documentation for details.

## 9. Current Implementation Status
This repository contains the frontend and backend source code. Some integrations and deployment capabilities may still be under development. Refer to the working demonstration for the features currently available.

## 10. AI Tool Disclosure
AI-assisted tools, including ChatGPT, were used for development assistance, debugging and documentation. The team is responsible for reviewing, understanding and explaining the submitted implementation.

## 11. Team
EARTHNEX AI — Hack-A-Sol 5.0

**GitHub Repository:** https://github.com/alfiyaafroz9-ai/EARTHNEX-AI
