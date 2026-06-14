FROM python:3.11-slim

WORKDIR /usr/app/ingestion

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENTRYPOINT ["python", "load_to_bronze.py"]