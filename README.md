# CppInterOp

[![Build Status](https://github.com/Gnimuc/CppInterOp.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Gnimuc/CppInterOp.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/Gnimuc/CppInterOp.jl/graph/badge.svg?token=dROvWMipWJ)](https://codecov.io/gh/Gnimuc/CppInterOp.jl)

CppInterOp.jl is a Julia wrapper for https://github.com/compiler-research/CppInterOp.

## Installation

```julia-repl
pkg> add CppInterOp
```

## Example

The following example demonstrates how to evaluate C++ code:

```julia-repl
julia> import CppInterOp as Cpp

julia> I = Cpp.create_interpreter()
CppInterOp.Interpreter(Ptr{CppInterOp.LibCppInterOp.CXInterpreterImpl}(0x0000600002c22df0))

julia> Cpp.declare(I, "#include <iostream>")
true

julia> Cpp.process(I, """std::cout << 42 << std::endl;""")
42
true
```
