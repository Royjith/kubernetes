# Use Alpine Linux as the base image
FROM python:3.12-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt and Python files into the container
COPY requirements.txt . 
COPY ui.py .

# Update package list and install dependencies
RUN apk update && \
    apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    curl

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Upgrade pip and setuptools
RUN python3 -m pip install --upgrade pip setuptools

# Expose the port the app will run on
EXPOSE 8501 

# Health check for the service
HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health || exit 1

# Set the entrypoint for the container
ENTRYPOINT ["streamlit", "run", "ui.py", "--server.port=8501", "--server.address=0.0.0.0"]
