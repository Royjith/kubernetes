# Use RHEL 7 as the base image
FROM registry.access.redhat.com/ubi7/python-39

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt and Python files into the container
COPY requirements.txt . 
COPY ui.py .

# Update package list and install dependencies
RUN yum -y update && \
    yum install -y \
    gcc \
    libffi-devel \
    curl \
    && yum clean all

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
