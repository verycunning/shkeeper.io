#!/bin/bash

# 1. Install System Dependencies (if not already present)
echo "Checking for system dependencies (python3, python3-pip, sqlite3)..."
sudo apt-get update
sudo apt-get install -y python3 python3-pip sqlite3 git curl

# 2. Set Up a Python Virtual Environment
echo "Setting up Python virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

# 3. Install Python Dependencies
echo "Installing Python dependencies from requirements.txt..."
pip install -r requirements.txt

# 4. Run the Application using gunicorn
echo "Disabling BTC, LTC, DOGE, XMR, and MONERO wallets for local development."
echo "If you need to enable a specific wallet, remove its corresponding environment variable from this script."
export BTC_WALLET=disabled
export LTC_WALLET=disabled
export DOGE_WALLET=disabled
export XMR_WALLET=disabled
export MONERO_WALLET=disabled

echo "Starting the application with gunicorn..."
echo "Access the application at http://localhost:5000"
gunicorn \
    --access-logfile - \
    --reload \
    --workers 1 \
    --threads 32 \
    --worker-class gthread \
    --timeout 30 \
    -b 0.0.0.0:5000 \
    "shkeeper:create_app()"
