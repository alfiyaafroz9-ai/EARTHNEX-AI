from .config import DATABASE_URL

database_enabled = bool(DATABASE_URL)

def initialize_database():
    if not database_enabled:
        print("PostgreSQL storage disabled (DATABASE_URL is empty)")
        return
    import psycopg
    sql = ("CREATE TABLE IF NOT EXISTS weather_observations ("
           "id BIGSERIAL PRIMARY KEY, location TEXT NOT NULL, "
           "latitude DOUBLE PRECISION NOT NULL, longitude DOUBLE PRECISION NOT NULL, "
           "observed_at TIMESTAMPTZ, temperature_c DOUBLE PRECISION, "
           "humidity_pct DOUBLE PRECISION, wind_kmh DOUBLE PRECISION, "
           "precipitation_mm DOUBLE PRECISION, created_at TIMESTAMPTZ DEFAULT NOW())")
    with psycopg.connect(DATABASE_URL) as conn:
        conn.execute(sql)
        conn.commit()
    print("PostgreSQL initialized (PostGIS not used)")

def save_weather(payload):
    if not database_enabled:
        return False
    import psycopg
    c = payload.get("current", {})
    sql = ("INSERT INTO weather_observations "
           "(location, latitude, longitude, observed_at, temperature_c, humidity_pct, wind_kmh, precipitation_mm) "
           "VALUES (%s,%s,%s,%s,%s,%s,%s,%s)")
    values = (payload.get("location", "Unknown"), payload.get("latitude"),
              payload.get("longitude"), c.get("time"), c.get("temperature_2m"),
              c.get("relative_humidity_2m"), c.get("wind_speed_10m"), c.get("precipitation"))
    with psycopg.connect(DATABASE_URL) as conn:
        conn.execute(sql, values)
        conn.commit()
    return True
