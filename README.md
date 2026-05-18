Docker workflow:

1. Write the code for the app
2. Create a docker file: It is a simple file named "Dockerfile" in your main project directory. which contains instructions to build an image. This will define OS, Python version, dependencides, startup commands
3. build the docker image using the command: "docker build -t <docker_name>"
4. Run the docker container using the command: "docker run -p <docker_name>"

----------------------------------------------------------------------------------

## Docker file contents:

### 1. FROM python:3.12-slim.  

 FROM will define the base image for your application
 slim because we are deploying smaller image size for faster deployment, less storage

 Usually there are 3 versions of python:
 a. python:3.12: Large
 b. python:3.12-slim: Smaller
 c. python:3.12-alpine: Very small

### 2. WORKDIR /app

This sets the working directory inside the container
Without working dir, files get copied to random locations
But with working dir, everything will stay organized

### 3. RUN apt-get update && apt-get install -y gcc g++ curl && rm -rf /var/lib/apt/lists/*
We are installing all the system dependencies
RUN- used to execute the command while building an image

apt-get: it is used to install OS-level software, bascially a package manager
update: will refresh the app

apt-get install -y gcc g++ curl: install the tools
gcc: C compiler
g++: c++ compiler
We need this because some python libraries internally uses C/C++. E.g. numpy, pandas, tokenizer. Without this pip install may fail
-y: is automatic yes for each step whenever asked

rm -rf /var/lib/apt/lists/*
deletes cached packages to reduce the image size. Otherwise unnecessary cache stays in the image

### 4. Upgrade the pip
RUN pip install --upgrade pip

PIP is python package manager.
we need to upgrade the pip because older pip version might fail to install dependencies, have bugs

## 5. Copy the requirements file 
COPY requirements2.txt .

Copies the requirement file from local to docker image in working directory

## 6. Pip timeout
RUN pip install --default-timeout=1000 --no-cache-dir -r requirements2.txt
It installs all the libraries (dependencies) mentioned in the requirements file
we have explicitly mentioned the timeout as 1000 seconds, because sometimes for genai app, dependencies might take a lot of time.


## 7. Copy the rest of the application code
COPY . .

It copies the entire project to the container.
Copy from current local folder to container folder.

Currently our project has backend, frontend, upload. all of this is copied to Working directory i.e. app

## 8. Create required directories
RUN mkdir -p backend/uploads

mkdir is used for creating a directory inside working directory
-p: creates a parent folder if missing


## 9. Expose the port
EXPOSE 8000

Which port will the application use.
It will bascially tell that application will listen on port 8000.
8000 is default common port for FastAPI/uvicorn

## 10. Command to run the application
CMD ["uvicorn", "backend.app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
This is the final startup command to run our application on the container




