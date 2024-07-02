"""
    allocate(x::AbstractRecordScope) -> CXObject
Allocate a struct/union/class object and return its address.
"""
function allocate(x::AbstractRecordScope)
    @check_ptrs x
    return clang_allocate(x)
end

"""
    deallocate(x::AbstractObject)
Deallocate an object that are allocated by [`allocate`](@ref).
"""
function deallocate(x::AbstractObject)
    @check_ptrs x
    clang_deallocate(x)
end

"""
    construct(x::AbstractRecordScope, arena=C_NULL) -> CXObject
Construct an object by calling its default constructor.
"""
function construct(x::AbstractRecordScope, arena=C_NULL)
    @check_ptrs x
    return clang_construct(x, arena)
end

"""
    destruct(x::AbstractObject, decl::AbstractRecordScope, free::Bool=true)
Destruct an object by calling its destructor.
"""
function destruct(obj::AbstractObject, decl::AbstractRecordScope, free::Bool=true)
    @check_ptrs obj decl
    clang_destruct(obj, decl, free)
end
