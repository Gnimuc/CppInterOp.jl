"""
    abstract type AbstractScope <: Any
Supertype for `Scope`s.
"""
abstract type AbstractScope end

"""
    struct Scope <: AbstractScope
"""
struct Scope <: AbstractScope
    ptr::CXScope
end

Base.unsafe_convert(::Type{CXScope}, x::Scope) = x.ptr
Base.cconvert(::Type{CXScope}, x::Scope) = x
