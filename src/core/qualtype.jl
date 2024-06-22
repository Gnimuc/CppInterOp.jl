"""
    abstract type AbstractQualType <: Any
Supertype for `QualType`s.
"""
abstract type AbstractQualType end

"""
    struct QualType <: AbstractQualType
"""
struct QualType <: AbstractQualType
    ptr::CXQualType
end

Base.unsafe_convert(::Type{CXQualType}, x::QualType) = x.ptr
Base.cconvert(::Type{CXQualType}, x::QualType) = x
