# Use a multi-stage build to create a Flask application in Docker

# Stage 1: Builder
FROM python:3.11-slim AS builder

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy artifacts from the builder stage
COPY --from=builder /app /app

# Copy the application files
COPY app.py .
COPY config/ config/

# Set environment variables for production
ENV FLASK_ENV=production
ENV PORT=5000

# Create a non-root user
RUN useradd -m flaskuser
USER flaskuser

# Add health check
HEALTHCHECK CMD curl --fail http://localhost:${PORT}/health || exit 1

# Expose the port
EXPOSE 5000

# Command to run the application
CMD ["gunicorn", "app:app", "--workers=4", "--bind=0.0.0.0:5000" ]