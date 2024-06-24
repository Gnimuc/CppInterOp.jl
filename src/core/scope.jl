"""
    struct Scope <: AbstractScope
"""
struct Scope <: AbstractScope
    ptr::CXScope
end

Base.unsafe_convert(::Type{CXScope}, x::Scope) = x.ptr
Base.cconvert(::Type{CXScope}, x::Scope) = x

"""
    struct TranslationUnitScope <: AbstractScope
"""
struct TranslationUnitScope <: AbstractScope
    ptr::CXScope
end

Base.unsafe_convert(::Type{CXScope}, x::TranslationUnitScope) = x.ptr
Base.cconvert(::Type{CXScope}, x::TranslationUnitScope) = x
