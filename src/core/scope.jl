"""
    struct Scope <: AbstractScope
"""
struct Scope <: AbstractScope
    scope::CXScope
end

Base.unsafe_convert(::Type{CXScope}, x::Scope) = x.scope
Base.cconvert(::Type{CXScope}, x::Scope) = x

"""
    struct TranslationUnitScope <: AbstractScope
"""
struct TranslationUnitScope <: AbstractScope
    scope::CXScope
end

Base.unsafe_convert(::Type{CXScope}, x::TranslationUnitScope) = x.scope
Base.cconvert(::Type{CXScope}, x::TranslationUnitScope) = x
