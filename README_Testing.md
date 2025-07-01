# Pascal Formatting Tests

This directory contains approval tests for Pascal code formatting using our enhanced clang-format.

## Setup

1. Install dependencies:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

2. Run tests:
```bash
./run_tests.sh
```

Or manually:
```bash
source venv/bin/activate
python test_pascal_formatting.py
```

## How It Works

- `tests/test_pascal_formatting.py` - Main test file using ApprovalTests framework
- `examples/DataProcessor.pas` - Source Pascal file to format
- `.clang-format` - Configuration for Pascal formatting
- `tests/*.approved.txt` - Approved baseline formatting output  
- `tests/*.received.txt` - Current formatting output (created during test failures)

## Adding New Tests

1. Add new Pascal source files to `examples/`
2. Add corresponding test methods to `PascalFormattingTest` class
3. Run tests to generate initial `.received.txt` files
4. Review the formatting and approve by copying to `.approved.txt`

## Current Test Cases

- **DataProcessor.pas** - Complete Pascal class with properties, getters, setters
  - Tests: unit declarations, interface/implementation sections, class structure, method formatting

## Known Formatting Issues

The current approved baseline shows several issues that need to be addressed:

1. **Unit name breaking**: Fixed ✅
2. **Interface section indentation**: Wrong indentation level
3. **Type declaration formatting**: Type and class declaration on same line
4. **Visibility modifier placement**: `private`/`public` not on separate lines  
5. **Progressive indentation**: Implementation methods getting progressively more indented
6. **Inconsistent function alignment**: Extra spaces in function declarations

## Usage

When making changes to Pascal formatting:

1. Run tests to see current state
2. Make formatting improvements in clang-format source
3. Rebuild clang-format
4. Run tests again - they will fail showing new formatting
5. Review the `.received.txt` files 
6. If formatting is improved, approve by copying to `.approved.txt`

This ensures we never regress on formatting quality while making improvements.