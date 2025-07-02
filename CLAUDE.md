# Pascal clang-format Testing

## Building
```bash
cd .. && ./build-clang-format.sh
```

## Testing
```bash
./run_tests.sh
```

## Tests
- `test_data_processor_formatting` - Default Pascal formatting
- `test_property_formatting_single_line` - SingleLine property style
- `test_property_formatting_multi_line` - MultiLine property style  
- `test_property_formatting_with_config_file` - File-based config testing

## Configs
Each test uses dedicated `.clang-format` files in `tests/configs/`:
- `pascal-default.clang-format` - Default settings
- `pascal-singleline.clang-format` - SingleLine properties
- `pascal-multiline.clang-format` - MultiLine properties

## Property Styles
**SingleLine**: `property Data: string read GetData write SetData;`
**MultiLine**: 
```pascal
property Data: string
  read GetData write SetData;
```

## Current Issues Under Investigation

### **Issue: Pascal Interface GUID Attribute Formatting**

**Problem Description:**
Pascal interface GUID attributes are not formatted correctly:
```pascal
// ❌ Current (incorrect):
ICalculator = interface['{12345678-1234-1234-1234-123456789ABC}']

// ✅ Expected (correct):
ICalculator = interface
  ['{12345678-1234-1234-1234-123456789ABC}']
```

**Root Cause Analysis:**
- Pascal attributes `[{...}]` should always be on new lines with proper indentation
- Interface type declarations vs unit sections need different handling
- Current parser logic for interface keyword detection is not distinguishing contexts correctly

**Investigation Findings:**
1. **Tokenization is correct**: `interface`, `[`, `'{GUID}'`, `]` are properly recognized as separate tokens
2. **Context detection failing**: Logic to distinguish unit sections vs type declarations needs refinement
3. **Parser logic added but not triggered**: Complex context detection in `UnwrappedLineParser.cpp` not being reached
4. **Line structure**: When parsing `ICalculator = interface`, the line contains `[ICalculator, =, interface]` tokens

**Technical Details:**
- **File**: `UnwrappedLineParser.cpp` lines 1496-1538
- **Approach**: Added context-aware parsing for `kw_pascal_interface` keyword
- **Issue**: Context detection logic (`isUnitSection` check) not working as expected
- **Debug Output**: GUID remains on same line as `interface` despite parsing logic

**Next Steps:**
1. Simplify context detection logic for interface type vs unit section
2. Add more targeted GUID attribute handling
3. Test with minimal examples to isolate the parsing issue

## What Was Learned
- Approval testing with pytest prevents regressions
- Dedicated test configs provide isolation
- clang-format configuration requires: enum definition, YAML mapping, default value, parser implementation
- Context-aware parsing needed for inline vs declaration `var` keywords
- Property formatting requires special handling in UnwrappedLineParser
- **Complex context detection can fail**: Simple, direct approaches often work better than complex conditional logic
- **Always check pwd when encountering 'no such file' errors**: Directory context is critical for relative paths

### **Pascal Function Colon Spacing Fix** ✅
- **Problem**: Functions with parameters had unwanted space: `function(A: Integer) : String`
- **Root Cause**: `TT_PascalVariableColon` detection only worked for `identifier : identifier` patterns, not `) : identifier`
- **Solution**: Extended TokenAnnotator detection logic to include `tok::r_paren` as valid predecessor
- **Fix**: `else if (Prev && (Prev->is(tok::identifier) || Prev->is(tok::r_paren)) && Tok->Next && Tok->Next->is(tok::identifier))`
- **Result**: All Pascal functions now format correctly: `function(A: Integer): String` ✅

### **Interface GUID Line Breaking - TokenAnnotator vs Parser Approach** ✅
- **Problem**: GUID attributes stayed on same line: `ICalculator = interface['{GUID}']`
- **Failed Approach**: Tried to handle in UnwrappedLineParser `parseStructuralElement()` 
  - Added complex logic to detect interface type vs unit sections
  - Logic was never reached - discovered through debug testing (no extra blank lines appeared)
  - Parser approach failed because tokens already processed/structured by time logic ran
- **Successful Approach**: Used TokenAnnotator `mustBreakBefore()` instead
  - Added simple rule: `if (Left.is(Keywords.kw_pascal_interface) && Right.is(tok::l_square)) return true;`
  - TokenAnnotator runs during line breaking phase, perfect timing for this type of formatting decision
  - **Result**: GUID properly breaks to new line ✅

### **Key Architecture Insights**
- **UnwrappedLineParser**: Best for structural parsing (blocks, sections, major language constructs)
- **TokenAnnotator**: Best for line breaking decisions and spacing rules between adjacent tokens
- **Debug Strategy**: When logic isn't working, add obvious visual changes (extra blank lines) to verify if code path is reached
- **Token Relationship Patterns**: `Left.is(X) && Right.is(Y)` patterns in TokenAnnotator are powerful for adjacent token formatting rules

## 🚧 Current Interface & Class Formatting Issues

### **Interface Content Indentation - Partially Fixed** ⚠️
- **GUID Fixed**: `['{GUID}']` now correctly indented with 2 spaces ✅
- **Function Inconsistency**: First function gets 8 spaces, second gets 2 spaces ❌
- **Root Cause**: Interface content parsing with `++Line->Level; parseStructuralElement(); --Line->Level;` creates uneven results
- **Investigation**: The per-element level adjustment in interface parsing causes inconsistent indentation

### **Class Public Section - Not Fixed** ❌  
- **Problem**: `public` remains on same line instead of separate line
- **Expected**: 
  ```pascal
  TBasicCalculator = class(TInterfacedObject, ICalculator)
  public
    function Add...
  ```
- **Current**:
  ```pascal  
  TBasicCalculator = class(TInterfacedObject, ICalculator)
  public
    function Add...
  ```
- **Investigation**: Visibility keyword parsing logic in `parsePascalTypeDeclaration()` not being reached or not working correctly

### **Next Debugging Steps**
1. **Interface Indentation**: Try alternative approach without per-element level management
2. **Class Sections**: Verify if class parsing logic is actually being executed
3. **Add Debug Output**: Insert temporary debug markers to verify code path execution