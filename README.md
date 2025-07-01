# clang-format with Pascal Language Support

This repository provides automated builds of clang-format with Pascal/Delphi language support.

## Features

- Complete Pascal/Delphi language support
- Context-aware inline variable formatting (`for var i := 1 to 10 do`)
- All Pascal keywords, operators, and comment styles
- Perfect variable declaration colon spacing (`x: integer`)
- Assignment operator support (`:=`)

## Downloads

The GitHub Actions workflow automatically builds clang-format for:
- **Linux x64** (Ubuntu-compatible)
- **Windows x64**

Download the latest builds from the [Actions tab](../../actions) or [Releases](../../releases).

## Source Code

This build is based on the Pascal language support implementation in:
https://github.com/partouf/llvm-project/tree/feature/pascal-language-support

## Usage

1. Download the appropriate archive for your platform
2. Extract the files
3. Use `clang-format` with Pascal files (`.pas`, `.dpr`, `.pp`, `.inc`)

### Example Configuration (.clang-format)

```yaml
Language: Pascal
AllowShortInlineVariablesOnASingleLine: true
AllowShortLoopsOnASingleLine: true
IndentWidth: 2
```

## Build from Source

To build locally:

```bash
git clone --branch feature/pascal-language-support https://github.com/partouf/llvm-project.git
cd llvm-project
cmake -S llvm -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang" -DLLVM_TARGETS_TO_BUILD="X86"
ninja -C build clang-format
```

## Pascal Language Support Details

This implementation includes:
- 57 Pascal/Delphi keywords
- Three comment styles: `{ }`, `(* *)`, `//`
- Context-aware `var` keyword processing
- Perfect assignment operator handling
- Modern Delphi inline variables support