# Pascal Examples

This directory contains Pascal source files used for testing clang-format's Pascal language support.

## Files

### DataProcessor.pas
- **Purpose**: Complete Pascal class example for comprehensive formatting testing
- **Features**: 
  - Unit declaration with dotted name (`Company.DataProcessor`)
  - Interface/implementation sections
  - Class with private fields and public properties
  - Property getters and setters
  - Method declarations and implementations
- **Use Cases**: Tests overall Pascal formatting including:
  - Unit structure
  - Class declarations
  - Visibility sections (private/public)
  - Property syntax
  - Method formatting
  - Implementation section organization

## Adding New Examples

When adding new Pascal examples:

1. Use generic, non-domain-specific names
2. Focus on specific Pascal language features to test
3. Include comments describing what the example tests
4. Ensure the code compiles with Free Pascal Compiler
5. Add corresponding test methods in `../tests/test_pascal_formatting.py`

## Pascal Language Features Covered

- [x] Unit declarations with dotted names
- [x] Interface/implementation sections  
- [x] Class declarations and inheritance
- [x] Private/public visibility sections
- [x] Property declarations with getters/setters
- [x] Method declarations and implementations
- [ ] Inline variables (`for var i := 1 to 10 do`)
- [ ] Nested classes
- [ ] Generics
- [ ] Exception handling
- [ ] Advanced OOP features