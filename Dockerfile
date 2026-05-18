## Use sslim python image
FROM python:3.12-slim

## Set the working directory
WORKDIR /app

## Installing system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

## Upgrade the pip
RUN pip install --upgrade pip

## Copy the requirements file 
COPY requirements2.txt .

## Pip timeout
RUN pip install --default-timeout=1000 --no-cache-dir -r requirements2.txt

## Copy the rest of the application code
COPY . .

## Create required directories
RUN mkdir -p backend/uploads

## Expose the port
EXPOSE 8000

## Command to run the application
CMD ["uvicorn", "backend.app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
