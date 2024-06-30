import Base.Enums.namemap

# each CXValueKind enum gets a specific Julia type wrapping
# so that we can dispatch directly on node kinds.
abstract type CppValue <: AbstractValue end

cxname2cppname(x::AbstractString) = "Cpp" * last(split(x, '_'; limit=2))
cxname2cppname(x::Symbol) = cxname2cppname(string(x))

const CXValueMap = Dict{CXValueKind,Any}()

for (i, sym) in namemap(CXValueKind)
    cppsym = Symbol(cxname2cppname(sym))
    @eval begin
        struct $cppsym <: CppValue
            ptr::CXValue
        end

        CXValueMap[$sym] = $cppsym
    end
end

CppValue(x::Value) = CXValueMap[getKind(x)](x.ptr)
Base.convert(::Type{T}, x::Value) where {T<:CppValue} = CppValue(x)
Base.cconvert(::Type{CXValue}, x::CppValue) = x
Base.unsafe_convert(::Type{CXValue}, x::CppValue) = x.ptr

get_value(x::CppValue) = error("Unsupported CXValueKind: $(getKind(x))")
get_value(x::CppBool) = getBool(x)
get_value(x::CppChar_S) = getChar_S(x)
get_value(x::CppSChar) = getSChar(x)
get_value(x::CppUChar) = getUChar(x)
get_value(x::CppShort) = getShort(x)
get_value(x::CppUShort) = getUShort(x)
get_value(x::CppInt) = getInt(x)
get_value(x::CppUInt) = getUInt(x)
get_value(x::CppLong) = getLong(x)
get_value(x::CppULong) = getULong(x)
get_value(x::CppLongLong) = getLongLong(x)
get_value(x::CppULongLong) = getULongLong(x)
get_value(x::CppFloat) = getFloat(x)
get_value(x::CppDouble) = getDouble(x)
get_value(x::CppLongDouble) = getLongDouble(x)
get_value(x::CppPtrOrObj) = getPtr(x)
get_value(x::CppVoid) = nothing


get_type(x::AbstractInterpreter, name::AbstractString) = getType(x, name)
get_type(x::AbstractScope) = getType(x)

get_scope(x::AbstractType) = getScopeFromType(x)

sizeof(x::AbstractType) = getSizeOfType(x)
sizeof(x::AbstractScope) = getSizeOf(x)

