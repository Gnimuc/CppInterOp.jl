# CppInterOp

[![Build Status](https://github.com/Gnimuc/CppInterOp.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Gnimuc/CppInterOp.jl/actions/workflows/CI.yml?query=branch%3Amain)

## Development

1. Build [Julia@1959349](https://github.com/JuliaLang/julia/commit/19593496a803c044ecb572087dbb2c19651d087e) from source and run:
```
LLVM_MAJOR_VER=`julia -e "print(Base.libllvm_version.major)"`
julia -e "using Pkg; pkg\"add LLVM_full_jll@${LLVM_MAJOR_VER}\""
LLVM_DIR=`julia -e "using LLVM_full_jll; print(LLVM_full_jll.artifact_dir)"`
echo "LLVM_DIR=$LLVM_DIR"
```

2. Build [CppInterOp](https://github.com/Gnimuc/CppInterOp/tree/jll-release-v1.3.0) by running:

```
cmake -B build -DLLVM_DIR=$LLVM_DIR/lib/cmake/llvm -DClang_DIR=$LLVM_DIR/lib/cmake/clang -DCMAKE_INSTALL_PREFIX=./install
cmake --build build --config Release --target install
```

3. Install the package and add the install directory to `deps/build_local.jl`

```
pkg> dev https://github.com/Gnimuc/CppInterOp.jl.git
```

```shell
cd deps
julia --project build_local.jl
```

4. Test the package by running:

```
pkg> activate CppInterOp

julia> import CppInterOp as Cpp

julia> Cpp.CreateInterpreter()
CppInterOp.CppInterpreter(Ptr{Nothing}(0x0000600001ee5180))

julia> Cpp.IsDebugOutputEnabled()
false

julia> Cpp.EnableDebugOutput()

julia> Cpp.IsDebugOutputEnabled()
true
```