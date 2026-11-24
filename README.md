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
## 12. Credits & Acknowledgements

### 1. Technologies Used
- Flutter & Dart — Frontend development.
- Python — Backend development and data processing.
- FastAPI — Backend API development (where implemented).

### 2. Data Sources & References
- NASA Earthdata — Earth science data discovery and research.
- NASA Open APIs — Public API documentation and data resources.
- Other environmental and Earth observation data providers, wherever integrated, are acknowledged through their respective source links and licences.

### 3. Open-Source Libraries & Frameworks
We sincerely acknowledge the developers and contributors of the open-source libraries, frameworks and tools used in EARTHNEX AI.

All third-party dependencies are referenced through:
- `frontend/pubspec.yaml`
- `backend/requirements.txt`

We respect the applicable open-source licences and attribution requirements of these dependencies.

### 4. AI Assistance Disclosure

AI-assisted tools were used during the development of EARTHNEX AI:

- **ChatGPT (GPT – OpenAI):** Used for coding assistance, debugging guidance, technical problem-solving and development suggestions.
- **Claude (Anthropic):** Used for coding assistance, reviewing implementation approaches and technical guidance.

The EARTHNEX AI team reviewed and evaluated the implementation, made development decisions and takes responsibility for the submitted project and its functionality.

### 5. Acknowledgements

We acknowledge NASA and the global open-data community for making Earth science resources accessible for research, exploration and innovation.

We also thank the organizers of **Hack-A-Sol 5.0, IIIT Naya Raipur**, for providing a platform to develop and present innovative technological solutions.

---

**Project Name:** EARTHNEX AI  
**Project Category:** Sustainability / Earth System Intelligence  
**Team Name:** EARTHNEX AI  
**GitHub Repository:** https://github.com/alfiyaafroz9-ai/EARTHNEX-AI