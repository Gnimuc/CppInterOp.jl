"""
    abstract type AbstractInterpreter <: Any
Supertype for interpreters.
"""
abstract type AbstractInterpreter end

"""
    struct Interpreter <: AbstractInterpreter
"""
struct Interpreter <: AbstractInterpreter
    ptr::CXInterpreter
end

Base.unsafe_convert(::Type{CXInterpreter}, x::Interpreter) = x.ptr
Base.cconvert(::Type{CXInterpreter}, x::Interpreter) = x
