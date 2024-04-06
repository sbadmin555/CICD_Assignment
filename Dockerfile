# Use a base image with Python installed
FROM python:3.11-slim AS build

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the training script
COPY train.py .

#Copy trainien dataset
COPY data/ /app/data/

# Run the training script during the build phase
RUN python train.py

# Start a new stage for the runtime environment
FROM python:3.11-slim AS runtime

# Set the working directory
WORKDIR /app

# Copy the trained model from the build stage
COPY --from=build /app/model.pkl .

# Copy the test script
COPY test.py .

# Command to run the test script when the container is run
CMD ["python", "test.py"]