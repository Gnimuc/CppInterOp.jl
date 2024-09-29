"""
    getType(x::AbstractInterpreter, name::AbstractString) -> CXQualType
Return the built-in type or use the name to look up the actual type.
"""
function getType(x::AbstractInterpreter, name::AbstractString)
    @check_ptrs x
    return clang_qualtype_getType(x, name)
end

"""
    getScopeFromType(x::CXQualType) -> CXScope
Return the scope from the type.
"""
function getScopeFromType(x::CXQualType)
    @assert is_valid(x) "Invalid type: $x"
    return clang_scope_getScopeFromType(x)
end

"""
    getSizeOfType(x::CXQualType) -> Int
Return the size of the type.
"""
function getSizeOfType(x::CXQualType)
    @assert is_valid(x) "Invalid type: $x"
    return clang_qualtype_getSizeOfType(x)
end

"""
    isBuiltin(x::CXQualType) -> Bool
Return true if the type is a "built-in" or a "complex" type.
"""
function isBuiltin(x::CXQualType)
    @assert is_valid(x) "Invalid type: $x"
    return clang_qualtype_isBuiltin(x)
end

# helper functions
is_valid(x::CXQualType) = x.kind != CXType_Invalid
