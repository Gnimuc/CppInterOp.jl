# interpreter
abstract type AbstractCppInterpreter end

struct CppInterpreter <: AbstractCppInterpreter
    ptr::CXCppInterpreter
end

Base.unsafe_convert(::Type{CXCppInterpreter}, x::CppInterpreter) = x.ptr
Base.cconvert(::Type{CXCppInterpreter}, x::CppInterpreter) = x

# scope
abstract type AbstractCppScope end

struct CppScope <: AbstractCppScope
    ptr::CXCppScope
end

Base.unsafe_convert(::Type{CXCppScope}, x::CppScope) = x.ptr
Base.cconvert(::Type{CXCppScope}, x::CppScope) = x


# type
abstract type AbstractCppType end

struct CppType <: AbstractCppType
    ptr::CXCppType
end

Base.unsafe_convert(::Type{CXCppType}, x::CppType) = x.ptr
Base.cconvert(::Type{CXCppType}, x::CppType) = x

# function
abstract type AbstractCppFunction end

struct CppFunction <: AbstractCppFunction
    ptr::CXCppFunction
end

Base.unsafe_convert(::Type{CXCppFunction}, x::CppFunction) = x.ptr
Base.cconvert(::Type{CXCppFunction}, x::CppFunction) = x

# const function
abstract type AbstractCppConstFunction end

struct CppConstFunction <: AbstractCppConstFunction
    ptr::CXCppConstFunction
end

Base.unsafe_convert(::Type{CXCppConstFunction}, x::CppConstFunction) = x.ptr
Base.cconvert(::Type{CXCppConstFunction}, x::CppConstFunction) = x

# function address
abstract type AbstractCppFuncAddr end

struct CppFuncAddr <: AbstractCppFuncAddr
    ptr::CXCppFuncAddr
end

Base.unsafe_convert(::Type{CXCppFuncAddr}, x::CppFuncAddr) = x.ptr
Base.cconvert(::Type{CXCppFuncAddr}, x::CppFuncAddr) = x

# object
abstract type AbstractCppObject end

struct CppObject <: AbstractCppObject
    ptr::CXCppObject
end

Base.unsafe_convert(::Type{CXCppObject}, x::CppObject) = x.ptr
Base.cconvert(::Type{CXCppObject}, x::CppObject) = x

# jitcall
abstract type AbstractCppJitCall end

struct CppJitCall <: AbstractCppJitCall
    ptr::CXCppJitCall
end

Base.unsafe_convert(::Type{CXCppJitCall}, x::CppJitCall) = x.ptr
Base.cconvert(::Type{CXCppJitCall}, x::CppJitCall) = x
