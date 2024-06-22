"""
    struct Value <: AbstractValue
"""
struct Value <: AbstractValue
    ptr::CXValue
end

Base.unsafe_convert(::Type{CXValue}, x::Value) = x.ptr
Base.cconvert(::Type{CXValue}, x::Value) = x
