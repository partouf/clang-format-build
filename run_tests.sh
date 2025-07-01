#!/bin/bash
set -e

# Activate virtual environment
source venv/bin/activate

# Run the formatting tests
echo "Running Pascal formatting approval tests..."
python -m pytest tests/test_pascal_formatting.py -v

echo "Tests completed!"