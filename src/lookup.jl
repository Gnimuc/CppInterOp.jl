"""
    lookup(name::AbstractString, parent::AbstractScope) -> Scope
"""
function lookup(name::AbstractString, parent::AbstractScope)
    s = parent
    for n in eachsplit(name, "::")
        isempty(n) && continue
        s = getScope(string(n), s)
    end
    return s
end

"""
    lookup(name::AbstractString, parent::AbstractScope) -> Scope
Look up a namespace or class (by stripping typedefs) by name.
"""
function lookup(x::AbstractInterpreter, name::AbstractString)
    @check_ptrs x
    return lookup(name, getGlocalScope(x))
end

"""
    name(x::AbstractScope) -> String
"""
name(x::AbstractScope) = getName(x)

"""
    fullname(x::AbstractScope) -> String
"""
fullname(x::AbstractScope) = getQualifiedName(x)

is_equal(x::CXScope, y::CXScope) = x.data == y.data
is_equal(x::Scope, y::Scope) = is_equal(x.scope, y.scope)
