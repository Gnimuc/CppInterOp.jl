# CppInterOp

[![Build Status](https://github.com/Gnimuc/CppInterOp.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Gnimuc/CppInterOp.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/Gnimuc/CppInterOp.jl/graph/badge.svg?token=dROvWMipWJ)](https://codecov.io/gh/Gnimuc/CppInterOp.jl)

## Installation

```
pkg> add https://github.com/Gnimuc/CppInterOp.jl.git
```

## Example

```
julia> using CppInterOp

julia> import CppInterOp as Cpp

julia> I = Cpp.create_interpreter()
CppInterOp.Interpreter(Ptr{CppInterOp.LibCppInterOp.CXInterpreterImpl}(0x0000000156091b00))

julia> Cpp.declare(I, "#include <iostream>")
true

julia> Cpp.process(I, """std::cout << 42 << std::endl;""")
42
true
```
