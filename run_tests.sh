#!/bin/bash
set -e

# Activate virtual environment
source venv/bin/activate

# Verify we're using the correct clang-format binary
echo "=== clang-format binary verification ==="
python -c "
import sys
import os
from datetime import datetime
sys.path.append('tests')
from test_pascal_formatting import PascalFormattingTest
test = PascalFormattingTest()
mtime = os.path.getmtime(test.clang_format_path)
mod_time = datetime.fromtimestamp(mtime).strftime('%Y-%m-%d %H:%M:%S')
print(f'Binary: {test.clang_format_path}')
print(f'Modified: {mod_time}')
"
echo "=========================================="

echo "Running Pascal formatting approval tests..."
python -m pytest tests/test_pascal_formatting.py -v

echo "Tests completed!"