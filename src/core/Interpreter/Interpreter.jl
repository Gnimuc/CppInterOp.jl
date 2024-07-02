"""
    struct Interpreter <: AbstractInterpreter
"""
struct Interpreter <: AbstractInterpreter
    ptr::CXInterpreter
end

Base.unsafe_convert(::Type{CXInterpreter}, x::Interpreter) = x.ptr
Base.cconvert(::Type{CXInterpreter}, x::Interpreter) = x
