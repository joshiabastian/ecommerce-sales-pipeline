FROM python:3.11-slim

WORKDIR /usr/app/dbt

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENTRYPOINT ["dbt"]