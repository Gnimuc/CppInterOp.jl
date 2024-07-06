"""
    getGlocalScope(x::AbstractInterpreter)->CXScope
Return the global scope a.k.a the root translation unit.
"""
function getGlocalScope(x::AbstractInterpreter)
    @check_ptrs x
    return clang_scope_getGlobalScope(x)
end

"""
    getScope(name::AbstractString, parent::CXScope) -> CXScope
Return the namespace or class (by stripping typedefs).
"""
function getScope(name::AbstractString, parent::CXScope)
    @assert is_valid(parent) "Invalid scope: $x"
    return clang_scope_getScope(name, parent)
end

"""
    getNamed(name::AbstractString, parent::CXScope) -> CXScope
"""
function getNamed(name::AbstractString, parent::CXScope)
    @assert is_valid(parent) "Invalid scope: $x"
    return clang_scope_getNamed(name, parent)
end

"""
    getName(x::CXScope) -> String
Return the name.
"""
function getName(x::CXScope)
    @assert is_valid(x) "Invalid scope: $x"
    return get_string(clang_scope_getName(x))
end

"""
    getQualifiedName(x::CXScope) -> String
Return the qualified name.
"""
function getQualifiedName(x::CXScope)
    @assert is_valid(x) "Invalid scope: $x"
    return get_string(clang_scope_getQualifiedName(x))
end

"""
    getSizeOf(x::CXScope) -> Int
Return the size of the scope.
"""
function getSizeOf(x::CXScope)
    @assert is_valid(x) "Invalid scope: $x"
    return clang_scope_getSizeOf(x)
end

"""
    getType(x::CXScope) -> CXQualType
Return the type from the scope.
"""
function getType(x::CXScope)
    @assert is_valid(x) "Invalid scope: $x"
    return clang_scope_getTypeFromScope(x)
end

function dump(x::CXScope)
    @assert is_valid(x) "Invalid scope: $x"
    clang_scope_dump(x)
end

function getFunctionReturnType(x::CXScope)
    @assert is_valid(x) "Invalid scope: $x"
    return clang_scope_getFunctionReturnType(x)
end

# helper functions
is_valid(x::CXScope) = x.kind != CXScope_Invalid
