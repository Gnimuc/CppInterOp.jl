"""
    lookup(name::AbstractString, parent::CXScope) -> CXScope
"""
function lookup(name::AbstractString, parent::CXScope)
    s = parent
    for n in eachsplit(name, "::")
        isempty(n) && continue
        s = getScope(string(n), s)
    end
    return s
end

"""
    lookup(name::AbstractString, parent::CXScope) -> CXScope
Look up a namespace or class (by stripping typedefs) by name.
"""
function lookup(x::AbstractInterpreter, name::AbstractString)
    @check_ptrs x
    return lookup(name, getGlocalScope(x))
end

"""
    name(x::CXScope) -> String
"""
name(x::CXScope) = getName(x)

"""
    fullname(x::CXScope) -> String
"""
fullname(x::CXScope) = getQualifiedName(x)
