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

## What Was Learned
- Approval testing with pytest prevents regressions
- Dedicated test configs provide isolation
- clang-format configuration requires: enum definition, YAML mapping, default value, parser implementation
- Context-aware parsing needed for inline vs declaration `var` keywords
- Property formatting requires special handling in UnwrappedLineParser