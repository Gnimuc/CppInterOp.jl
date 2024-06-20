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

julia> create_interpreter()
CppInterOp.CppInterpreter(Ptr{Nothing}(0x0000600001585580))

julia> Cpp.Declare("#include <iostream>")
0

julia> Cpp.Process("""std::cout << 42 << std::endl;""")
42
0
```
