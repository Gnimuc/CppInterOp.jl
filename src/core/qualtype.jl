"""
    struct QualType <: AbstractType
"""
struct QualType <: AbstractType
    ptr::CXQualType
end

Base.unsafe_convert(::Type{CXQualType}, x::QualType) = x.ptr
Base.cconvert(::Type{CXQualType}, x::QualType) = x
