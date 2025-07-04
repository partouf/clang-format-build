#!/bin/bash

# Format all Pascal files (.pas, .dpr, .pp, .inc) in current directory
# Uses .clang-format file for style configuration
# Always formats in-place and recursively

# Find clang-format binary
if [ -f "../llvm-project-pascal/build/bin/clang-format" ]; then
    CLANG_FORMAT="../llvm-project-pascal/build/bin/clang-format"
elif command -v clang-format &> /dev/null; then
    CLANG_FORMAT="clang-format"
else
    echo "Error: clang-format not found!"
    echo "Please build clang-format with Pascal support first."
    exit 1
fi

echo "Using: $CLANG_FORMAT"

# Check for .clang-format file
if [ ! -f ".clang-format" ]; then
    echo "Error: No .clang-format file found!"
    echo "Please create a .clang-format file with Language: Pascal"
    exit 1
fi

# Find and format all Pascal files
echo "Formatting Pascal files..."
find . -type f \( -name "*.pas" -o -name "*.dpr" -o -name "*.pp" -o -name "*.inc" \) -print0 | \
    while IFS= read -r -d '' file; do
        echo "  $file"
        "$CLANG_FORMAT" -i "$file"
    done

echo "Done!"