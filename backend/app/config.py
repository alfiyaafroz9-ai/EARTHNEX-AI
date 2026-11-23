import os
from dotenv import load_dotenv

load_dotenv()
LOCATION_NAME = os.getenv("APP_LOCATION", "Nagpur, Maharashtra, India")
LATITUDE = float(os.getenv("LATITUDE", "21.1458"))
LONGITUDE = float(os.getenv("LONGITUDE", "79.0882"))
DATABASE_URL = os.getenv("DATABASE_URL", "").strip()
