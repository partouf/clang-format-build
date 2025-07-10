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
        self.project_root = Path(__file__).parent.parent
        self.clang_format_path = self._find_clang_format()
        self.test_configs_dir = Path(__file__).parent / "configs"
        
    def _find_clang_format(self):
        """Find the clang-format executable."""
        # Check for environment variable first (for CI)
        env_path = os.environ.get('CLANG_FORMAT_PATH')
        if env_path and Path(env_path).exists():
            return env_path
            
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
    
    def format_pascal_code(self, source_code: str, style_config: str = None) -> str:
        """Format Pascal source code using clang-format.
        
        Args:
            source_code: The Pascal source code to format
            style_config: Optional style configuration (file path or inline YAML)
        """
        with tempfile.NamedTemporaryFile(mode='w', suffix='.pas', delete=False) as f:
            f.write(source_code)
            temp_file = f.name
        
        try:
            if style_config:
                if style_config.startswith('{'):
                    # Inline YAML style
                    cmd = [self.clang_format_path, f"--style={style_config}", temp_file]
                else:
                    # File-based style
                    cmd = [self.clang_format_path, f"--style=file:{style_config}", temp_file]
            else:
                default_config = self.test_configs_dir / "pascal-default.clang-format"
                cmd = [self.clang_format_path, f"--style=file:{default_config}", temp_file]
            
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
    
    def test_property_formatting_single_line(self):
        """Test Pascal property formatting with SingleLine style."""
        source_file = self.project_root / "examples" / "DataProcessor.pas"
        singleline_config = self.test_configs_dir / "pascal-singleline.clang-format"
        
        with open(source_file, 'r') as f:
            source_code = f.read()
        
        # Use dedicated SingleLine property formatting config
        formatted_code = self.format_pascal_code(source_code, str(singleline_config))
        
        # Verify the formatted code against approved baseline
        verify(formatted_code)
    
    def test_property_formatting_multi_line(self):
        """Test Pascal property formatting with MultiLine style."""
        source_file = self.project_root / "examples" / "DataProcessor.pas"
        multiline_config = self.test_configs_dir / "pascal-multiline.clang-format"
        
        with open(source_file, 'r') as f:
            source_code = f.read()
        
        # Use dedicated MultiLine property formatting config
        formatted_code = self.format_pascal_code(source_code, str(multiline_config))
        
        # Verify the formatted code against approved baseline
        verify(formatted_code)
    
    def test_property_formatting_with_config_file(self):
        """Test Pascal property formatting using dedicated multiline config file."""
        source_file = self.project_root / "examples" / "DataProcessor.pas"
        multiline_config = self.test_configs_dir / "pascal-multiline.clang-format"
        
        with open(source_file, 'r') as f:
            source_code = f.read()
        
        formatted_code = self.format_pascal_code(source_code, str(multiline_config))
        
        # Verify the formatted code against approved baseline
        verify(formatted_code)
    
    def test_simple_interface_formatting(self):
        """Test formatting simple interface and class with basic methods."""
        source_file = self.project_root / "examples" / "SimpleInterface.pas"
        
        with open(source_file, 'r') as f:
            source_code = f.read()
        
        default_config = self.test_configs_dir / "pascal-default.clang-format"
        formatted_code = self.format_pascal_code(source_code, str(default_config))
        
        # Verify the formatted code against approved baseline
        verify(formatted_code)

    def test_nested_begin_end_formatting(self):
        """Test formatting nested begin/end blocks to verify indentation levels."""
        source_file = self.project_root / "examples" / "test_nested_begin.pas"
        
        with open(source_file, 'r') as f:
            source_code = f.read()
        
        default_config = self.test_configs_dir / "pascal-default.clang-format"
        formatted_code = self.format_pascal_code(source_code, str(default_config))
        
        # Verify the formatted code against approved baseline
        verify(formatted_code)
    
    def test_virtuals_formatting(self):
        """Test formatting virtual methods and abstract classes."""
        source_file = self.project_root / "examples" / "virtuals.pas"
        
        with open(source_file, 'r') as f:
            source_code = f.read()
        
        default_config = self.test_configs_dir / "pascal-default.clang-format"
        formatted_code = self.format_pascal_code(source_code, str(default_config))
        
        # Verify the formatted code against approved baseline
        verify(formatted_code)
    
    def test_simple_database(self):
        """Test formatting simple database class with ExecuteQuery method."""
        source_file = self.project_root / "examples" / "SimpleDatabase.pas"
        
        with open(source_file, 'r') as f:
            source_code = f.read()
        
        default_config = self.test_configs_dir / "pascal-default.clang-format"
        formatted_code = self.format_pascal_code(source_code, str(default_config))
        
        # Verify the formatted code against approved baseline
        verify(formatted_code)
    
    def test_anonymous_function(self):
        """Test formatting anonymous function in Pascal."""
        source_file = self.project_root / "examples" / "SimpleAnonymousFunction.pas"
        
        with open(source_file, 'r') as f:
            source_code = f.read()
        
        default_config = self.test_configs_dir / "pascal-default.clang-format"
        formatted_code = self.format_pascal_code(source_code, str(default_config))
        
        # Verify the formatted code against approved baseline
        verify(formatted_code)


def test_data_processor_formatting():
    """Pytest entry point for data processor formatting test."""
    test = PascalFormattingTest()
    test.test_data_processor_class()


def test_property_formatting_single_line():
    """Pytest entry point for SingleLine property formatting test."""
    test = PascalFormattingTest()
    test.test_property_formatting_single_line()


def test_property_formatting_multi_line():
    """Pytest entry point for MultiLine property formatting test."""
    test = PascalFormattingTest()
    test.test_property_formatting_multi_line()


def test_property_formatting_with_config_file():
    """Pytest entry point for config file property formatting test."""
    test = PascalFormattingTest()
    test.test_property_formatting_with_config_file()


def test_simple_interface_formatting():
    """Pytest entry point for simple interface formatting test."""
    test = PascalFormattingTest()
    test.test_simple_interface_formatting()


def test_nested_begin_end_formatting():
    """Pytest entry point for nested begin/end formatting test."""
    test = PascalFormattingTest()
    test.test_nested_begin_end_formatting()


def test_virtuals_formatting():
    """Pytest entry point for virtual methods formatting test."""
    test = PascalFormattingTest()
    test.test_virtuals_formatting()


def test_simple_database():
    """Pytest entry point for simple database formatting test."""
    test = PascalFormattingTest()
    test.test_simple_database()


def test_anonymous_function():
    """Pytest entry point for anonymous function formatting test."""
    test = PascalFormattingTest()
    test.test_anonymous_function()


if __name__ == "__main__":
    test = PascalFormattingTest()
    
    print("Running all Pascal formatting tests...")
    print("1. Testing default data processor formatting...")
    test.test_data_processor_class()
    
    print("2. Testing SingleLine property formatting...")
    test.test_property_formatting_single_line()
    
    print("3. Testing MultiLine property formatting...")
    test.test_property_formatting_multi_line()
    
    print("4. Testing config file property formatting...")
    test.test_property_formatting_with_config_file()
    
    print("5. Testing simple interface formatting...")
    test.test_simple_interface_formatting()
    
    print("6. Testing nested begin/end formatting...")
    test.test_nested_begin_end_formatting()
    
    print("7. Testing virtual methods formatting...")
    test.test_virtuals_formatting()
    
    print("8. Testing simple database formatting...")
    test.test_simple_database()
    
    print("All tests completed successfully!")