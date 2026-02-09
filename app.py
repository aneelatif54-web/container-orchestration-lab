from flask import Flask, jsonify
import logging

app = Flask(__name__)

# Logging setup
logging.basicConfig(level=logging.INFO)

@app.route('/health', methods=['GET'])
def health_check():
    logging.info("Health check endpoint called")
    return jsonify(status="healthy"), 200

@app.route('/metrics', methods=['GET'])
def metrics():
    logging.info("Metrics endpoint called")
    # Here you can include logic to gather application metrics
    return jsonify(metrics={"example_metric": 1}), 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)