"""
    getType(x::AbstractInterpreter, name::AbstractString) -> QualType
Return the built-in type or use the name to look up the actual type.
"""
function getType(x::AbstractInterpreter, name::AbstractString)
    @check_ptrs x
    return QualType(clang_qualtype_getType(x, name))
end

"""
    getScopeFromType(x::AbstractType) -> Scope
Return the scope from the type.
"""
function getScopeFromType(x::AbstractType)
    @assert is_valid(x) "Invalid type: $x"
    return Scope(clang_scope_getScopeFromType(x))
end

"""
    getSizeOfType(x::AbstractType) -> Int
Return the size of the type.
"""
function getSizeOfType(x::AbstractType)
    @assert is_valid(x) "Invalid type: $x"
    return clang_qualtype_getSizeOfType(x)
end

"""
    isBuiltin(x::AbstractType) -> Bool
Return true if the type is a "built-in" or a "complex" type.
"""
function isBuiltin(x::AbstractType)
    @assert is_valid(x) "Invalid type: $x"
    return clang_qualtype_isBuiltin(x)
end

# helper functions
is_valid(x::AbstractType) = x.ptr.kind != CXType_Invalid
