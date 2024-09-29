module LibCppInterOpExtra

using ..CppInterOp: libCppInterOp, libCppInterOpExtra
using ..CppInterOp: CXErrorCode, CXTypeKind, CXString, CXStringSet, CXValue

const intptr_t = Clong


function clang_CppInterOp_EnableDebugOutput(value)
    @ccall libCppInterOpExtra.clang_CppInterOp_EnableDebugOutput(value::Bool)::Cvoid
end

function clang_CppInterOp_IsDebugOutputEnabled()
    @ccall libCppInterOpExtra.clang_CppInterOp_IsDebugOutputEnabled()::Bool
end

function clang_createValueFromType(I, Ty)
    @ccall libCppInterOpExtra.clang_createValueFromType(I::Ptr{Cvoid}, Ty::Ptr{Cvoid})::CXValue
end

function clang_value_getType(V)
    @ccall libCppInterOpExtra.clang_value_getType(V::CXValue)::Ptr{Cvoid}
end

function clang_value_isValid(V)
    @ccall libCppInterOpExtra.clang_value_isValid(V::CXValue)::Bool
end

function clang_value_isVoid(V)
    @ccall libCppInterOpExtra.clang_value_isVoid(V::CXValue)::Bool
end

function clang_value_hasValue(V)
    @ccall libCppInterOpExtra.clang_value_hasValue(V::CXValue)::Bool
end

function clang_value_isManuallyAlloc(V)
    @ccall libCppInterOpExtra.clang_value_isManuallyAlloc(V::CXValue)::Bool
end

@enum CXValueKind::UInt32 begin
    CXValue_Bool = 0
    CXValue_Char_S = 1
    CXValue_SChar = 2
    CXValue_UChar = 3
    CXValue_Short = 4
    CXValue_UShort = 5
    CXValue_Int = 6
    CXValue_UInt = 7
    CXValue_Long = 8
    CXValue_ULong = 9
    CXValue_LongLong = 10
    CXValue_ULongLong = 11
    CXValue_Float = 12
    CXValue_Double = 13
    CXValue_LongDouble = 14
    CXValue_Void = 15
    CXValue_PtrOrObj = 16
    CXValue_Unspecified = 17
end

function clang_value_getKind(V)
    @ccall libCppInterOpExtra.clang_value_getKind(V::CXValue)::CXValueKind
end

function clang_value_setKind(V, K)
    @ccall libCppInterOpExtra.clang_value_setKind(V::CXValue, K::CXValueKind)::Cvoid
end

function clang_value_setOpaqueType(V, Ty)
    @ccall libCppInterOpExtra.clang_value_setOpaqueType(V::CXValue, Ty::Ptr{Cvoid})::Cvoid
end

function clang_value_getPtr(V)
    @ccall libCppInterOpExtra.clang_value_getPtr(V::CXValue)::Ptr{Cvoid}
end

function clang_value_setPtr(V, P)
    @ccall libCppInterOpExtra.clang_value_setPtr(V::CXValue, P::Ptr{Cvoid})::Cvoid
end

function clang_value_setBool(V, Val)
    @ccall libCppInterOpExtra.clang_value_setBool(V::CXValue, Val::Bool)::Cvoid
end

function clang_value_getBool(V)
    @ccall libCppInterOpExtra.clang_value_getBool(V::CXValue)::Bool
end

function clang_value_setChar_S(V, Val)
    @ccall libCppInterOpExtra.clang_value_setChar_S(V::CXValue, Val::Cchar)::Cvoid
end

function clang_value_getChar_S(V)
    @ccall libCppInterOpExtra.clang_value_getChar_S(V::CXValue)::Cchar
end

function clang_value_setSChar(V, Val)
    @ccall libCppInterOpExtra.clang_value_setSChar(V::CXValue, Val::Int8)::Cvoid
end

function clang_value_getSChar(V)
    @ccall libCppInterOpExtra.clang_value_getSChar(V::CXValue)::Int8
end

function clang_value_setUChar(V, Val)
    @ccall libCppInterOpExtra.clang_value_setUChar(V::CXValue, Val::Cuchar)::Cvoid
end

function clang_value_getUChar(V)
    @ccall libCppInterOpExtra.clang_value_getUChar(V::CXValue)::Cuchar
end

function clang_value_setShort(V, Val)
    @ccall libCppInterOpExtra.clang_value_setShort(V::CXValue, Val::Cshort)::Cvoid
end

function clang_value_getShort(V)
    @ccall libCppInterOpExtra.clang_value_getShort(V::CXValue)::Cshort
end

function clang_value_setUShort(V, Val)
    @ccall libCppInterOpExtra.clang_value_setUShort(V::CXValue, Val::Cushort)::Cvoid
end

function clang_value_getUShort(V)
    @ccall libCppInterOpExtra.clang_value_getUShort(V::CXValue)::Cushort
end

function clang_value_setInt(V, Val)
    @ccall libCppInterOpExtra.clang_value_setInt(V::CXValue, Val::Cint)::Cvoid
end

function clang_value_getInt(V)
    @ccall libCppInterOpExtra.clang_value_getInt(V::CXValue)::Cint
end

function clang_value_setUInt(V, Val)
    @ccall libCppInterOpExtra.clang_value_setUInt(V::CXValue, Val::Cuint)::Cvoid
end

function clang_value_getUInt(V)
    @ccall libCppInterOpExtra.clang_value_getUInt(V::CXValue)::Cuint
end

function clang_value_setLong(V, Val)
    @ccall libCppInterOpExtra.clang_value_setLong(V::CXValue, Val::Clong)::Cvoid
end

function clang_value_getLong(V)
    @ccall libCppInterOpExtra.clang_value_getLong(V::CXValue)::Clong
end

function clang_value_setULong(V, Val)
    @ccall libCppInterOpExtra.clang_value_setULong(V::CXValue, Val::Culong)::Cvoid
end

function clang_value_getULong(V)
    @ccall libCppInterOpExtra.clang_value_getULong(V::CXValue)::Culong
end

function clang_value_setLongLong(V, Val)
    @ccall libCppInterOpExtra.clang_value_setLongLong(V::CXValue, Val::Clonglong)::Cvoid
end

function clang_value_getLongLong(V)
    @ccall libCppInterOpExtra.clang_value_getLongLong(V::CXValue)::Clonglong
end

function clang_value_setULongLong(V, Val)
    @ccall libCppInterOpExtra.clang_value_setULongLong(V::CXValue, Val::Culonglong)::Cvoid
end

function clang_value_getULongLong(V)
    @ccall libCppInterOpExtra.clang_value_getULongLong(V::CXValue)::Culonglong
end

function clang_value_setFloat(V, Val)
    @ccall libCppInterOpExtra.clang_value_setFloat(V::CXValue, Val::Cfloat)::Cvoid
end

function clang_value_getFloat(V)
    @ccall libCppInterOpExtra.clang_value_getFloat(V::CXValue)::Cfloat
end

function clang_value_setDouble(V, Val)
    @ccall libCppInterOpExtra.clang_value_setDouble(V::CXValue, Val::Cdouble)::Cvoid
end

function clang_value_getDouble(V)
    @ccall libCppInterOpExtra.clang_value_getDouble(V::CXValue)::Cdouble
end

function clang_value_setLongDouble(V, Val)
    @ccall libCppInterOpExtra.clang_value_setLongDouble(V::CXValue, Val::Float64)::Cvoid
end

function clang_value_getLongDouble(V)
    @ccall libCppInterOpExtra.clang_value_getLongDouble(V::CXValue)::Float64
end

# exports
const PREFIXES = ["clang", "CX"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
