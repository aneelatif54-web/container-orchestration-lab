FROM python:3.11-slim as builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY app.py .
COPY config/ ./config/ 2>/dev/null || true
ENV PATH=/root/.local/bin:$PATH
FLASK_ENV=production
PYTHONUNBUFFERED=1
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD python -c 'import requests; requests.get(\'http://localhost:5000/health\') || exit 1'
EXPOSE 5000
CMD gunicorn --workers=4 --worker-class=sync --bind=0.0.0.0:5000 --timeout=60 app:app