"""
	createValue() -> Value
Create a opaque pointer to `clang::Value`.
"""
createValue() = Value(clang_createValue())

dispose(x::Value) = clang_value_dispose(x)

function getType(x::Value)
    @check_ptrs x
    return clang_value_getType(x)
end

function isManuallyAlloc(x::Value)
    @check_ptrs x
    return clang_value_isManuallyAlloc(x)
end

function getKind(x::Value)
    @check_ptrs x
    return clang_value_getKind(x)
end

function setKind(x::Value, kind::CXValueKind)
    @check_ptrs x
    clang_value_setKind(x, kind)
end

function getPtr(x::Value)
    @check_ptrs x
    return clang_value_getPtr(x)
end

function setPtr(x::Value, ptr::Ptr{Cvoid})
    @check_ptrs x
    clang_value_setPtr(x, ptr)
end
