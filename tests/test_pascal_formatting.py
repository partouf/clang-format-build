#!/usr/bin/env python3
"""
Pascal formatting tests using approval testing.

This module tests clang-format's Pascal language support by comparing
formatted output against approved baseline files.
"""

import os
import subprocess
import tempfile
from pathlib import Path
from approvaltests import verify


class PascalFormattingTest:
    """Test class for Pascal code formatting using clang-format."""
    
    def __init__(self):
        self.project_root = Path(__file__).parent.parent  # Go up one level from tests/ to project root
        self.clang_format_path = self._find_clang_format()
        self.clang_format_config = self.project_root / ".clang-format"
        
    def _find_clang_format(self):
        """Find the clang-format executable."""
        # Try local build first
        local_path = self.project_root.parent / "llvm-project-pascal" / "build" / "bin" / "clang-format"
        if local_path.exists():
            return str(local_path)
        
        # Fall back to system clang-format
        try:
            result = subprocess.run(["which", "clang-format"], 
                                  capture_output=True, text=True, check=True)
            return result.stdout.strip()
        except subprocess.CalledProcessError:
            raise RuntimeError("Could not find clang-format executable")
    
    def format_pascal_code(self, source_code: str) -> str:
        """Format Pascal source code using clang-format."""
        with tempfile.NamedTemporaryFile(mode='w', suffix='.pas', delete=False) as f:
            f.write(source_code)
            temp_file = f.name
        
        try:
            cmd = [
                self.clang_format_path,
                f"--style=file:{self.clang_format_config}",
                temp_file
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            return result.stdout
        except subprocess.CalledProcessError as e:
            raise RuntimeError(f"clang-format failed: {e.stderr}")
        finally:
            os.unlink(temp_file)
    
    def test_data_processor_class(self):
        """Test formatting of a complete Pascal class with properties and methods."""
        source_file = self.project_root / "examples" / "DataProcessor.pas"
        
        with open(source_file, 'r') as f:
            source_code = f.read()
        
        formatted_code = self.format_pascal_code(source_code)
        
        # Verify the formatted code against approved baseline
        verify(formatted_code)


def test_data_processor_formatting():
    """Pytest entry point for data processor formatting test."""
    test = PascalFormattingTest()
    test.test_data_processor_class()


if __name__ == "__main__":
    # Direct execution for manual testing
    test = PascalFormattingTest()
    test.test_data_processor_class()
    print("Test completed successfully!")