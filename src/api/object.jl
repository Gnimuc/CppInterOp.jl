"""
    allocate(x::CXScope) -> CXObject
Allocate a struct/union/class object and return its address.
"""
function allocate(x::CXScope)
    @check_ptrs x
    return clang_allocate(x)
end

"""
    deallocate(x::CXObject)
Deallocate an object that are allocated by [`allocate`](@ref).
"""
function deallocate(x::CXObject)
    @check_ptrs x
    clang_deallocate(x)
end

"""
    construct(x::CXScope, arena=C_NULL) -> CXObject
Construct an object by calling its default constructor.
"""
function construct(x::CXScope, arena=C_NULL)
    @check_ptrs x
    return clang_construct(x, arena)
end

"""
    destruct(x::CXObject, decl::CXScope, free::Bool=true)
Destruct an object by calling its destructor.
"""
function destruct(obj::CXObject, decl::CXScope, free::Bool=true)
    @check_ptrs obj decl
    clang_destruct(obj, decl, free)
end
