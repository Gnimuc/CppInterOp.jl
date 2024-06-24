"""
    getGlocalScope(x::AbstractInterpreter)->TranslationUnitScope
Return the global scope a.k.a the root translation unit.
"""
function getGlocalScope(x::AbstractInterpreter)
    @check_ptrs x
    return TranslationUnitScope(clang_scope_getGlobalScope(x))
end

"""
    getScope(name::AbstractString, parent::AbstractScope) -> Scope
Return the namespace or class (by stripping typedefs).
"""
function getScope(name::AbstractString, parent::AbstractScope)
    @assert is_valid(parent) "Invalid scope: $x"
    return Scope(clang_scope_getScope(name, parent))
end

"""
    getNamed(name::AbstractString, parent::AbstractScope) -> Scope
"""
function getNamed(name::AbstractString, parent::AbstractScope)
    @assert is_valid(parent) "Invalid scope: $x"
    return Scope(clang_scope_getNamed(name, parent))
end

"""
    getName(x::AbstractScope) -> String
Return the name.
"""
function getName(x::AbstractScope)
    @assert is_valid(x) "Invalid scope: $x"
    return get_string(clang_scope_getName(x))
end

"""
    getQualifiedName(x::AbstractScope) -> String
Return the qualified name.
"""
function getQualifiedName(x::AbstractScope)
    @assert is_valid(x) "Invalid scope: $x"
    return get_string(clang_scope_getQualifiedName(x))
end

# helper functions
is_valid(x::AbstractScope) = x.ptr.kind != CXScope_Invalid

function dump(x::AbstractScope)
    @assert is_valid(x) "Invalid scope: $x"
    clang_scope_dump(x)
end
