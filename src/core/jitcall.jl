"""
    abstract type AbstractJitCall <: Any
Supertype for `JitCall`s.
"""
abstract type AbstractJitCall end

"""
    struct JitCall <: AbstractJitCall
"""
struct JitCall <: AbstractJitCall
    ptr::CXJitCall
end

Base.unsafe_convert(::Type{CXJitCall}, x::JitCall) = x.ptr
Base.cconvert(::Type{CXJitCall}, x::JitCall) = x
