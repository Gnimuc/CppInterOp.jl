# CppInterOp

[![Build Status](https://github.com/Gnimuc/CppInterOp.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Gnimuc/CppInterOp.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/Gnimuc/CppInterOp.jl/graph/badge.svg?token=dROvWMipWJ)](https://codecov.io/gh/Gnimuc/CppInterOp.jl)

## Installation

```
pkg> dev https://github.com/Gnimuc/CppInterOp.jl.git
```

```shell
julia --project=deps deps/build_local.jl
```

Test the package by running:

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
