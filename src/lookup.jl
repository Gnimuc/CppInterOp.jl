"""
    lookup(name::AbstractString, parent::AbstractScope) -> Scope
"""
function lookup(name::AbstractString, parent::AbstractScope)
    s = parent
    for n in eachsplit(name, "::")
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
    lookup_sugar(name::AbstractString, parent::AbstractScope) -> Scope
"""
function lookup_sugar(name::AbstractString, parent::AbstractScope)
    @check_ptrs parent
    return getNamed(name, parent)
end
